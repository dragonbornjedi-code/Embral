extends Area3D
## Quest-giver stub for HubWorld NPCs (Area3D + interact).

@export var npc_name: String = "Guide"
@export var npc_id: String = ""
@export var npc_color: Color = Color.WHITE
@export var primary_category: String = "L"
@export_multiline var greeting: String = "Hello!"
@export_multiline var quest_offer: String = "Want a quest?"
@export_multiline var quest_complete: String = "Well done!"
@export_multiline var no_quests: String = "Nothing right now."

var _player_in_range: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		_player_in_range = true
		body.set_meta("interact_target", self)
		EventBus.npc_discovered.emit(_slug_id())


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		_player_in_range = false
		if body.has_meta("interact_target") and body.get_meta("interact_target") == self:
			body.remove_meta("interact_target")


func _slug_id() -> String:
	if npc_id != "":
		return npc_id
	return npc_name.to_lower().replace(" ", "_").replace("'", "")


func interact() -> void:
	var npc_id := _slug_id()
	EventBus.npc_dialogue_started.emit(npc_id)
	var stub := get_node_or_null("/root/DialogicStub")
	if stub != null and stub.has_method(&"start_timeline"):
		stub.call(&"start_timeline", npc_id)
	else:
		print("[%s]: %s" % [npc_name, greeting])
	await get_tree().create_timer(1.0).timeout
	EventBus.npc_dialogue_ended.emit(npc_id)
