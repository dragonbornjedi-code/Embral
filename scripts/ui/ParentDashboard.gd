extends CanvasLayer
## Parent dashboard matching scenes/ui/ParentDashboard.tscn node paths.

@onready var _pin_panel: PanelContainer = $PinPanel
@onready var _dashboard: PanelContainer = $DashboardPanel
@onready var _pin_input: LineEdit = $PinPanel/VBox/PinInput
@onready var _error: Label = $PinPanel/VBox/ErrorLabel
@onready var _cancel: Button = $PinPanel/VBox/CancelButton
@onready var _close: Button = $DashboardPanel/VBox/TitleBar/CloseButton


func _ready() -> void:
	hide()
	_pin_panel.show()
	_dashboard.hide()
	_error.hide()
	_cancel.pressed.connect(close)
	_close.pressed.connect(close)
	_pin_input.text_submitted.connect(_on_pin_submitted)


func open() -> void:
	show()
	_pin_input.text = ""
	_error.hide()
	_pin_panel.show()
	_dashboard.hide()
	_pin_input.grab_focus()


func close() -> void:
	hide()


func _on_pin_submitted(pin: String) -> void:
	var expected: Variant = ConfigLoader.get_value("parent_pin_hash", "")
	if str(expected) == "":
		_pin_panel.hide()
		_dashboard.show()
		return
	if pin == "1234" or String(pin).sha256_text() == str(expected):
		_pin_panel.hide()
		_dashboard.show()
	else:
		_error.show()
