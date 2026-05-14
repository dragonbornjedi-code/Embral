extends Node3D

const TUTORIAL_QUEST_ID := "hv_ignavarr_tutorial_01"
const HUBWORLD_PATH := "res://scenes/overworld/hearthveil/HubWorld.tscn"

var _platform_reached := false
var _coin_collected := false
var _ignavarr_met := false

@onready var _player: Node3D = $Player
@onready var _platform: Node3D = $Platform1
@onready var _hud: CanvasLayer = $PlayerHUD


func _ready() -> void:
	if SaveManager.active_profile != null and SaveManager.active_profile.tutorial_completed:
		TransitionManager.change_scene(HUBWORLD_PATH)
		return
	if SaveManager.active_profile != null and SaveManager.active_profile.tutorial_intro_completed:
		TransitionManager.change_scene(HUBWORLD_PATH)
		return

	if not EventBus.gold_gained.is_connected(_on_gold_gained):
		EventBus.gold_gained.connect(_on_gold_gained)
	if not EventBus.npc_dialogue_started.is_connected(_on_npc_dialogue_started):
		EventBus.npc_dialogue_started.connect(_on_npc_dialogue_started)

	QuestManager.start_quest(TUTORIAL_QUEST_ID)
	_set_objective("Meet Ignavarr and learn movement. Use WASD, arrow keys, left stick, or D-pad to walk to the brown platform.")


func _process(_delta: float) -> void:
	if _platform_reached or not is_instance_valid(_player) or not is_instance_valid(_platform):
		return
	if _player.global_position.distance_to(_platform.global_position) <= 4.0:
		_platform_reached = true
		QuestManager.complete_step()
		_set_objective("Pick up the glowing coin on the platform.")


func _on_gold_gained(_amount: int, source: String) -> void:
	if _coin_collected or source != "collection" or not _platform_reached:
		return
	_coin_collected = true
	QuestManager.complete_step()
	_set_objective("Return to Ignavarr and press E, Space, or the controller confirm button.")


func _on_npc_dialogue_started(npc_id: String) -> void:
	if _ignavarr_met or not _coin_collected or npc_id != "ignavarr":
		return
	_ignavarr_met = true
	QuestManager.complete_step()
	if SaveManager.active_profile != null:
		SaveManager.active_profile.tutorial_intro_completed = true
		SaveManager.save_current_profile()
	_set_objective("Great. Ignavarr is opening Hearthveil so you can visit each realm portal.")
	await get_tree().create_timer(1.2).timeout
	TransitionManager.change_scene(HUBWORLD_PATH)


func _set_objective(text: String) -> void:
	if _hud != null and _hud.has_method("set_tutorial_objective"):
		_hud.call("set_tutorial_objective", "A Dragon's Welcome", text)
