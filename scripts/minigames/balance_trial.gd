extends Node2D

var bar: ColorRect
var zone: ColorRect
var speed: float = 200.0
var direction: int = 1
var round_count: int = 0

func _ready() -> void:
    bar = ColorRect.new()
    bar.size = Vector2(20, 100)
    bar.color = Color.RED
    add_child(bar)
    
    zone = ColorRect.new()
    zone.size = Vector2(60, 100)
    zone.position = Vector2(400, 100)
    zone.color = Color.GREEN
    add_child(zone)

func _process(delta: float) -> void:
    bar.position.x += speed * delta * direction
    if bar.position.x > 800 or bar.position.x < 0:
        direction *= -1

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_accept"):
        _check_timing()

func _check_timing() -> void:
    var bar_center = bar.position.x + 10
    if bar_center > zone.position.x and bar_center < zone.position.x + 60:
        round_count += 1
        speed *= 1.1
        if round_count >= 5:
            EventBus.xp_gained.emit(10, "balance_trial")
    else:
        # No penalty
        pass
