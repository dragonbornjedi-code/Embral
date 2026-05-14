extends Control
## Minimal on-screen joystick visuals; input routing can be expanded for mobile.

@export var base_color: Color = Color(0.2, 0.5, 0.8, 0.35)
@export var stick_color: Color = Color(0.3, 0.7, 1.0, 0.85)
@export var active_color: Color = Color(0.4, 0.8, 1.0, 1.0)
@export var base_radius: float = 75.0
@export var stick_radius: float = 35.0
@export var dead_zone: float = 0.12
@export var dynamic_position: bool = true
@export var idle_alpha: float = 0.4


func _draw() -> void:
	var c := size * 0.5
	draw_circle(c, base_radius, Color(base_color.r, base_color.g, base_color.b, idle_alpha))
	draw_circle(c, stick_radius, stick_color)
