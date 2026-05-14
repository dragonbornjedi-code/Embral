extends Area3D
## Shopkeeper interact → opens sibling ShopUI on the current hub scene.

@export var npc_name: String = "Merchant"
@export var npc_color: Color = Color(1, 0.85, 0, 1)
@export_multiline var greeting: String = "Welcome!"
@export_multiline var shop_prompt: String = "Press E to shop."
@export_multiline var farewell: String = "Come again!"

var _player_in_range: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		_player_in_range = true
		body.set_meta("interact_target", self)


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		_player_in_range = false
		if body.has_meta("interact_target") and body.get_meta("interact_target") == self:
			body.remove_meta("interact_target")


func interact() -> void:
	var npc_id := "shopkeeper_" + npc_name.to_lower().replace(" ", "_")
	EventBus.npc_dialogue_started.emit(npc_id)
	var hub := get_tree().current_scene
	if hub:
		var shop := hub.get_node_or_null("ShopUI")
		if shop != null and shop.has_method(&"open"):
			shop.call(&"open")
	await get_tree().create_timer(0.3).timeout
	EventBus.npc_dialogue_ended.emit(npc_id)
