extends CanvasLayer
## ParentDashboard — PIN-gated interface for progress monitoring.

const LOG_PATH = "user://save/parent_dashboard.json"

@onready var pin_panel = %PINPanel
@onready var dashboard_panel = %DashboardPanel
@onready var pin_input = %PINInput
@onready var error_label = %ErrorLabel
@onready var pin_notice = %PINNotice

@onready var checkin_list = %CheckinList

func _ready() -> void:
	$Control.hide()
	pin_panel.show()
	dashboard_panel.hide()
	error_label.text = ""


func open() -> void:
	$Control.show()
	var pin_hash = ConfigLoader.get_value("parent_pin_hash", "")
	if pin_hash == "":
		pin_notice.text = "Notice: Set a PIN in Settings to protect this dashboard."
		# For first run or no PIN, allow entry but show notice
		# In a stricter version, we might skip PIN entry entirely
	else:
		pin_notice.text = "Enter your 4-digit Parent PIN"


func close() -> void:
	$Control.hide()
	_clear_pin()


func _clear_pin() -> void:
	pin_input.text = ""
	error_label.text = ""


func _on_pin_input_text_submitted(new_text: String) -> void:
	var pin_hash = ConfigLoader.get_value("parent_pin_hash", "")
	
	# Simple direct match for white-box (should use hashing in real build)
	if pin_hash == "" or new_text == pin_hash:
		_show_dashboard()
	else:
		error_label.text = "Incorrect PIN. Try again."
		pin_input.text = ""


func _show_dashboard() -> void:
	pin_panel.hide()
	dashboard_panel.show()
	_refresh_data()


func _refresh_data() -> void:
	_load_emotional_checkins()


func _load_emotional_checkins() -> void:
	# Clear existing
	for child in checkin_list.get_children():
		child.queue_free()
	
	if not FileAccess.file_exists(LOG_PATH):
		var label = Label.new()
		label.text = "No emotional check-in data yet."
		checkin_list.add_child(label)
		return
	
	var file = FileAccess.open(LOG_PATH, FileAccess.READ)
	var parsed = JSON.parse_string(file.get_as_text())
	file.close()
	
	if not parsed is Array:
		return
		
	# Show last 5
	var last_5 = parsed.slice(-5)
	last_5.reverse() # Newest first
	
	for entry in last_5:
		var label = Label.new()
		var time = Time.get_datetime_string_from_unix_time(entry.get("timestamp", 0), true)
		var emotion = entry.get("emotion", "unknown")
		label.text = "%s — %s" % [time, emotion.capitalize()]
		checkin_list.add_child(label)


func _on_close_button_pressed() -> void:
	close()
