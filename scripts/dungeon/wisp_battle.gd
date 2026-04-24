extends Node
## WispBattle — Battle system stub.

class_name WispBattle

enum BattleState {PLAYER_TURN, ENEMY_TURN, VICTORY, DEFEAT}

@export var player_wisp_id: String
@export var enemy_wisp_id: String

var player_hp: int = 100
var enemy_hp: int = 100
var current_state: BattleState

func start_battle() -> void:
	current_state = BattleState.PLAYER_TURN
	EventBus.battle_started.emit(player_wisp_id, enemy_wisp_id)

func player_attack(_card_id: String) -> void:
	push_warning("[WispBattle] player_attack not implemented.")

func enemy_attack() -> void:
	push_warning("[WispBattle] enemy_attack not implemented.")

func check_battle_end() -> void:
	if player_hp <= 0:
		current_state = BattleState.DEFEAT
	elif enemy_hp <= 0:
		current_state = BattleState.VICTORY

func end_battle(victory: bool) -> void:
	var xp := 20 if victory else 0
	EventBus.battle_ended.emit(victory, xp)
	if victory:
		EventBus.xp_gained.emit(20, "battle_victory")
