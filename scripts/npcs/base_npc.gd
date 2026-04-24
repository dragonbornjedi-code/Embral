extends CharacterBody3D
## BaseNPC — Base class for all NPCs.
## Handles proximity detection, interaction, and quest dispatch.

class_name BaseNPC

@export_group("NPC Identity")
@export var npc_id: String = "generic_npc"
@export var npc_name: String = "Unknown NPC"
@export var npc_title: String = ""
@export var realm: String = "realm_0"

@export_group("Dialogue")
@export var greeting_dialogue: String = "" # Dialogic timeline ID
@export var fallback_lines: Array[String] = ["Hello there!"]

var _player_in_range: bool = false
var _is_interacting: bool = false
var _interact_label: Label3D = null

@onready var interaction_area: Area3D = $InteractionArea


func _ready() -> void:
	add_to_group("npcs")
	if interaction_area:
		interaction_area.body_entered.connect(_on_body_entered)
		interaction_area.body_exited.connect(_on_body_exited)
	
	_create_whitebox_ui()


func _exit_tree() -> void:
	if is_instance_valid(interaction_area):
		if interaction_area.body_entered.is_connected(_on_body_entered):
			interaction_area.body_entered.disconnect(_on_body_entered)
		if interaction_area.body_exited.is_connected(_on_body_exited):
			interaction_area.body_exited.disconnect(_on_body_exited)


func _create_whitebox_ui() -> void:
	_interact_label = Label3D.new()
	_interact_label.text = "Press E to talk"
	_interact_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	_interact_label.position.y = 2.5
	_interact_label.no_depth_test = true
	_interact_label.hide()
	add_child(_interact_label)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		_player_in_range = true
		_interact_label.show()
		# Discovery event
		EventBus.npc_discovered.emit(npc_id)


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		_player_in_range = false
		_interact_label.hide()
		if _is_interacting:
			_end_interaction()


func interact() -> void:
	## Virtual method to be overridden by subclasses.
	_start_interaction()
	_is_interacting = true
	_interact_label.hide()
	EventBus.npc_dialogue_started.emit(npc_id)
	
	# Logic:
	# 1. Check for available quests
	# 2. If quest available, offer it
	# 3. Else, just say greeting
	
	var quest_mgr = get_node_or_null("/root/QuestManager")
	var available_quests = []
	if quest_mgr:
		# Use a default level if profile system is missing (should be 1)
		var level = SaveManager.active_profile.level if SaveManager.active_profile else 1
		available_quests = quest_mgr.get_available_quests_for_npc(npc_id, level)
	
	if not available_quests.is_empty():
		# For tutorial, we'll just start the first available one
		_launch_dialogue(greeting_dialogue, true, available_quests[0])
	else:
		_launch_dialogue(greeting_dialogue, false)


func _launch_dialogue(timeline_id: String, has_quest: bool = false, quest_id: String = "") -> void:
	var player_name = "Explorer"
	if SaveManager.active_profile:
		player_name = SaveManager.active_profile.player_name

	var dialogic = get_node_or_null("/root/DialogicStub")
	if dialogic:
		dialogic.start_timeline(timeline_id)
		if has_quest and quest_id != "":
			QuestManager.start_quest(quest_id)
	else:
		# Fallback to simple print/popup
		var raw_line = fallback_lines[0]
		var final_line = raw_line.replace("{player}", player_name)
		print("[%s]: %s" % [npc_name, final_line])
		if has_quest:
			QuestManager.start_quest(quest_id)
	
	# Simulate dialogue duration for now
	await get_tree().create_timer(1.0).timeout
	_end_interaction()


func _end_interaction() -> void:
	_is_interacting = false
	if _player_in_range:
		_interact_label.show()
	EventBus.npc_dialogue_ended.emit(npc_id)
