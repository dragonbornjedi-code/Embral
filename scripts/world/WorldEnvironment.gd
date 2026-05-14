extends Node
## Companion to the HubWorld **WorldEnvironment** node: validates that a world Environment is present.

func _ready() -> void:
	var we := get_parent().get_node_or_null("WorldEnvironment") as WorldEnvironment
	if we == null:
		push_warning("[WorldEnvironment] Sibling WorldEnvironment node not found.")
		return
	if we.environment == null:
		push_warning("[WorldEnvironment] WorldEnvironment.environment is unset.")
