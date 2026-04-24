extends Area3D
## Coin — A simple collectible that notifies the EventBus when collected.

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		_collect()


func _collect() -> void:
	# Broadcast to the breathing ecosystem
	EventBus.gold_gained.emit(1, "collection")
	EventBus.sfx_requested.emit("coin_collect", global_position)
	
	# Visual feedback/cleanup
	# In a real build, we'd trigger a tween or particle here
	queue_free()
