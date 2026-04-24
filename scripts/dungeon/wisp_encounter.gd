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
    
    # Create Battle Logic
    var battle = WispBattle.new()
    add_child(battle)
    battle.start_battle(player_wisp_id, enemy_id)
    
    # Link UI (Assuming WispBattleUI is an autoload or accessible)
    # Using a simple lookup for this phase
    var battle_ui = get_tree().root.find_child("WispBattleUI", true, false)
    if battle_ui:
        battle_ui.open(battle)
    
    battle.state_changed.connect(func(state): if state == WispBattle.BattleState.VICTORY or state == WispBattle.BattleState.DEFEAT: on_battle_won())

func attempt_capture() -> bool:
	if randf() <= capture_chance_base:
		var wisp = WispData.new()
		wisp.wisp_id = "%s_%d_%d" % [encounter_wisp_element, encounter_wisp_level, Time.get_unix_time_from_system()]
		wisp.element = encounter_wisp_element
		wisp.level = encounter_wisp_level
		WispRoster.add_wisp(wisp)
		EventBus.wisp_captured.emit(wisp.wisp_id)
		return true
	return false

func get_capture_chance_display() -> String:
	return "%.0f%%" % (capture_chance_base * 100)

func on_battle_won() -> void:
	is_defeated = true
	attempt_capture()
	EventBus.xp_gained.emit(10 * encounter_wisp_level, "wisp_defeat")
