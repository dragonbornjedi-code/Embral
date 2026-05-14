extends Node3D
## Root coordinator for Hearthveil HubWorld. Scene layout and Environment are authored in HubWorld.tscn;
## extend here for hub boot (portals, pooled NPCs) without bloating the .tscn.

var _spark_coins_found: int = 0
var _met_ignavarr: bool = false

const TUTORIAL_REALMS := ["ember_hollow", "tidemark", "forge_run", "rootstead", "the_spire", "the_drift"]
const REALM_LABELS := {
	"ember_hollow": "The Ember Hollow",
	"tidemark": "The Tidemark",
	"forge_run": "The Forge Run",
	"rootstead": "The Rootstead",
	"the_spire": "The Spire",
	"the_drift": "The Drift"
}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	_setup_landmark_triggers()
	_update_first_steps()
	if EventBus.has_signal("gold_gained"):
		EventBus.gold_gained.connect(_on_gold_gained)
	if EventBus.has_signal("npc_dialogue_started"):
		EventBus.npc_dialogue_started.connect(_on_npc_dialogue_started)


func _setup_landmark_triggers() -> void:
	_add_area_trigger("DungeonMaintenanceTrigger", Vector3(22, 1.5, 22), Vector3(4, 3, 3), _on_dungeon_gate_entered)
	_add_area_trigger("PlayerHouseDoorTrigger", Vector3(-22, 1.5, -15), Vector3(4, 3, 3), _on_player_house_door_entered)


func _add_area_trigger(trigger_name: String, trigger_position: Vector3, trigger_size: Vector3, callback: Callable) -> void:
	if has_node(trigger_name):
		return
	var area := Area3D.new()
	area.name = trigger_name
	area.collision_layer = 0
	area.collision_mask = 2
	area.position = trigger_position
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = trigger_size
	collision.shape = shape
	area.add_child(collision)
	add_child(area)
	area.body_entered.connect(callback)


func _on_dungeon_gate_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	_show_hud_message("The dungeon is under construction. Come back later!")


func _on_player_house_door_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	var profile := SaveManager.active_profile
	if profile != null and profile.house_unlocked:
		if ResourceLoader.exists("res://scenes/overworld/hearthveil/player_house.tscn"):
			TransitionManager.change_scene("res://scenes/overworld/hearthveil/player_house.tscn")
		else:
			_show_hud_message("Your house is unlocked. The inside room is not built yet.")
	else:
		_show_hud_message("Ignavarr will unlock your house when you finish the tutorial.")


func _on_ignavarr_interact_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	EventBus.npc_dialogue_started.emit("ignavarr_the_dragon")
	_show_hud_message("Ignavarr: The portals lead to the six realms. The dungeon gate is under maintenance.")


func _show_hud_message(text: String) -> void:
	var hud := get_node_or_null("PlayerHUD")
	if hud != null and hud.has_method("show_message"):
		hud.call("show_message", text)
	elif hud != null and hud.has_method("set_hub_objective"):
		hud.call("set_hub_objective", text)


func _on_gold_gained(_amount: int, source: String) -> void:
	if source != "collection":
		return
	_spark_coins_found += 1
	_update_first_steps()


func _on_npc_dialogue_started(npc_id: String) -> void:
	if npc_id.begins_with("ignavarr"):
		_met_ignavarr = true
		if _tutorial_realm_tour_complete() and SaveManager.active_profile != null and not SaveManager.active_profile.tutorial_completed:
			_finish_full_tutorial()
			return
		_update_first_steps()


func _update_first_steps() -> void:
	var next_text := ""
	if SaveManager.active_profile != null and SaveManager.active_profile.tutorial_intro_completed and not SaveManager.active_profile.tutorial_completed:
		next_text = _tutorial_realm_tour_text()
	elif _spark_coins_found < 3:
		next_text = "Collect 3 spark coins near the path. Found: %d / 3" % _spark_coins_found
	elif not _met_ignavarr:
		next_text = "Great. Walk to Ignavarr and press E or Space to talk."
	else:
		next_text = "First steps complete. Explore Hearthveil and meet another guide."
	var hud := get_node_or_null("PlayerHUD")
	if hud != null and hud.has_method("set_hub_objective"):
		hud.call("set_hub_objective", next_text)


func _tutorial_realm_tour_text() -> String:
	var completed := SaveManager.active_profile.tutorial_realms_completed
	if _tutorial_realm_tour_complete():
		return "All six realm guide quests are done. Return to Ignavarr to see your new house and meet your first pet."
	var next_realm := _next_tutorial_realm()
	return "Tutorial: portals lead to the six realms. Dungeon gate is under maintenance. Visit %s next, complete one guide quest, then return here." % REALM_LABELS.get(next_realm, "the next realm")


func _next_tutorial_realm() -> String:
	var completed := SaveManager.active_profile.tutorial_realms_completed
	for realm_id in TUTORIAL_REALMS:
		if not completed.has(realm_id):
			return realm_id
	return ""


func _tutorial_realm_tour_complete() -> bool:
	if SaveManager.active_profile == null:
		return false
	var completed := SaveManager.active_profile.tutorial_realms_completed
	for realm_id in TUTORIAL_REALMS:
		if not completed.has(realm_id):
			return false
	return true


func _finish_full_tutorial() -> void:
	var profile := SaveManager.active_profile
	profile.tutorial_completed = true
	profile.house_unlocked = true
	profile.pet_unlocked = true
	profile.first_pet_id = "ember_sprout"
	if profile.level < 2:
		profile.level = 2
		profile.xp = 0
		profile.xp_to_next_level = int(100 * profile.level * 1.2)
		EventBus.level_up.emit(profile.level)
	SaveManager.save_current_profile()
	var hud := get_node_or_null("PlayerHUD")
	if hud != null and hud.has_method("set_hub_objective"):
		hud.call("set_hub_objective", "Welcome home. Your house is unlocked, you reached level 2, and your first pet is waiting.")
