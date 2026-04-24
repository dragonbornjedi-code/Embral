extends BaseNPC
## BaseTeacherNPC — Base class for all Teacher NPCs.
## Handles quest filtering and dispatch based on player progress.

class_name BaseTeacherNPC

@export_group("Teacher Data")
@export var available_quests: Array[String] = [] # List of quest IDs this teacher can give

func _ready() -> void:
	super._ready()
	add_to_group("teacher_npc")


func interact() -> void:
	_start_interaction()

func _start_interaction() -> void:
	_is_interacting = true
	_interact_label.hide()
	EventBus.npc_dialogue_started.emit(npc_id)
	
	var next_quest = _get_next_quest()
	
	if next_quest != "":
		# If a quest is active, give progress hint (simple for now)
		if QuestManager._active_quest == next_quest:
			_launch_dialogue(greeting_dialogue, false)
		else:
			_launch_dialogue(greeting_dialogue, true, next_quest)
	else:
		# All quests completed
		var player_name = "Explorer"
		if SaveManager.active_profile:
			player_name = SaveManager.active_profile.player_name
		
		var dialogic = get_node_or_null("/root/DialogicStub")
		if dialogic:
			dialogic.start_timeline(greeting_dialogue)
		else:
			var no_quest_line = "You're doing so well, {player}!".replace("{player}", player_name)
			print("[%s]: %s" % [npc_name, no_quest_line])
		
		await get_tree().create_timer(1.0).timeout
		_end_interaction()


func _get_next_quest() -> String:
	for quest_id in available_quests:
		if not QuestManager.is_quest_completed(quest_id):
			return quest_id
	return ""
