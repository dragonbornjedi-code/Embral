extends BaseNPC
## BuildersGuildNPC — Guides player to fulfill NPC home preferences.

func interact() -> void:
	super.interact()
	var list := []
	var npcs = get_tree().get_nodes_in_group("npcs")
	
	for n in npcs:
		if n.get("home_data"):
			if not n.home_data.validate(get_tree().current_scene):
				list.append(n.display_name)
	
	var msg = ""
	if list.is_empty():
		msg = "Everyone is happy in their home!"
	else:
		msg = "These friends need help: " + ", ".join(list)
		
	# Simple dialogue (white-box)
	print("[%s]: %s" % [npc_name, msg])
	EventBus.npc_dialogue_started.emit(npc_id)
	await get_tree().create_timer(2.0).timeout
	EventBus.npc_dialogue_ended.emit(npc_id)
