extends Node
## WispEncounter — Handles the Wisp battle encounter trigger.

class_name WispEncounter

@export var encounter_wisp_element: String = "fire"
@export var encounter_wisp_level: int = 1
@export var capture_chance_base: float = 0.3
@export var is_defeated: bool = false

func _ready() -> void:
	add_to_group("wisp_encounters")
	# Validate element
	if not encounter_wisp_element in CrystalSystem.ELEMENT_TYPES:
		push_error("[WispEncounter] Invalid element: %s" % encounter_wisp_element)

func trigger_encounter(player_wisp_id: String) -> void:
	if is_defeated: return
	var enemy_id = "%s_encounter_%d" % [encounter_wisp_element, encounter_wisp_level]
	EventBus.battle_started.emit(player_wisp_id, enemy_id)
	# WispBattle instance creation logic would follow here

func attempt_capture() -> bool:
	if randf() <= capture_chance_base:
		var wisp = WispData.new()
		wisp.wisp_id = "%s_%d" % [encounter_wisp_element, Time.get_unix_time_from_system()]
		wisp.element = encounter_wisp_element
		wisp.level = encounter_wisp_level
		WispRoster.add_wisp(wisp)
		EventBus.wisp_captured.emit(wisp.wisp_id)
		return true
	return false

func on_battle_won() -> void:
	is_defeated = true
	attempt_capture()
	EventBus.xp_gained.emit(10 * encounter_wisp_level, "wisp_defeat")
