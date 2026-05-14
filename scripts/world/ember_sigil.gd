extends Area3D
## EmberSigil — Original hidden Hearthveil collectible.

@export var sigil_number: int = 1


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		_collect()


func _collect() -> void:
	EventBus.show_notification.emit("You found Ember Sigil %d!" % sigil_number, "collectible")
	EventBus.sfx_requested.emit("coin_collect", global_position)
	queue_free()
