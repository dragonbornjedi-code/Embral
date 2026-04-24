extends CanvasLayer
## EmotionalCheckin — Periodic popup for emotional self-reflection.
## Logs results to user://save/parent_dashboard.json.

const LOG_PATH = "user://save/parent_dashboard.json"

@onready var timer = $CheckinTimer

func _ready() -> void:
	# Hide on start
	$Control.hide()
	
	# Start periodic timer (30 mins)
	timer.wait_time = 1800.0
	timer.start()
	timer.timeout.connect(_on_timer_timeout)
	
	# Also show once on game start (after a brief delay for profile load)
	await get_tree().create_timer(5.0).timeout
	show_checkin()


func show_checkin() -> void:
	$Control.show()
	call_deferred("_set_initial_focus")


func hide_checkin() -> void:
	$Control.hide()


func _on_emotion_pressed(emotion: String) -> void:
	_log_emotion(emotion)
	EventBus.xp_gained.emit(10, "emotional_checkin")
	hide_checkin()


func _log_emotion(emotion: String) -> void:
	var data = []
	if FileAccess.file_exists(LOG_PATH):
		var file = FileAccess.open(LOG_PATH, FileAccess.READ)
		var parsed = JSON.parse_string(file.get_as_text())
		if parsed is Array:
			data = parsed
	
	data.append({
		"timestamp": int(Time.get_unix_time_from_system()),
		"emotion": emotion,
		"player_id": SaveManager.active_profile.profile_id if SaveManager.active_profile else "unknown"
	})
	
	var file = FileAccess.open(LOG_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()


func _on_timer_timeout() -> void:
	show_checkin()


func _set_initial_focus() -> void:
	var buttons = find_children("*", "Button", true, false)
	if buttons.size() > 0:
		buttons[0].grab_focus()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		hide_checkin()


func _on_close_pressed() -> void:
	hide_checkin()
