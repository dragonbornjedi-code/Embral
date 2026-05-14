extends CanvasLayer
## Lightweight celebration / flash feedback.

@onready var _flash: ColorRect = $FlashRect


func _ready() -> void:
	if EventBus.has_signal("celebration_triggered"):
		EventBus.celebration_triggered.connect(_on_celebration)
	_flash.color.a = 0.0


func _on_celebration(_intensity: String) -> void:
	var tw := create_tween()
	_flash.color.a = 0.35
	tw.tween_property(_flash, "color:a", 0.0, 0.35)
