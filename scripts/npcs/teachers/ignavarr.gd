extends BaseTeacherNPC
## Ignavarr — The Dragon Mayor of Hearthveil.
## Hosts the tutorial, unlocks realms, and manages nightly reviews.

class_name Ignavarr

func _ready() -> void:
	super._ready()
	npc_id = "ignavarr"
	npc_name = "Ignavarr"
	realm = "hearthveil"
	available_quests = ["hv_ignavarr_tutorial_01"]


func interact() -> void:
	if not QuestManager.is_quest_completed("hv_ignavarr_tutorial_01"):
		# Start tutorial if not done
		QuestManager.start_quest("hv_ignavarr_tutorial_01")
		_launch_dialogue(greeting_dialogue, true, "hv_ignavarr_tutorial_01")
	else:
		# Random encouraging line
		_launch_dialogue(greeting_dialogue, false)


func _on_tutorial_complete() -> void:
	# Unlock all realm portals
	for i in range(1, 7):
		EventBus.realm_unlocked.emit("realm_%d" % i)
