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


func _on_tutorial_complete() -> void:
	# Unlock all realm portals
	var realm_ids = ["realm_1","realm_2","realm_3","realm_4","realm_5","realm_6"]
	for rid in realm_ids:
		EventBus.realm_unlocked.emit(rid)
