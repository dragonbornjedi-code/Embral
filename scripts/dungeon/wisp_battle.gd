extends Node
class_name WispBattle

signal state_changed(state: BattleState)
signal hp_changed(is_player: bool, new_hp: int)

enum BattleState {PLAYER_TURN, ENEMY_TURN, VICTORY, DEFEAT}

var current_state: BattleState = BattleState.PLAYER_TURN
var player_hp: int = 100
var enemy_hp: int = 100
var player_wisp_id: String = ""
var enemy_wisp_id: String = ""

func start_battle() -> void:
	current_state = BattleState.PLAYER_TURN
	if EventBus.has_signal("battle_started"):
		EventBus.battle_started.emit(player_wisp_id, enemy_wisp_id)
	state_changed.emit(current_state)

func player_attack(card_id: String) -> void:
	if current_state != BattleState.PLAYER_TURN:
		return
	var damage = 20
	enemy_hp = max(0, enemy_hp - damage)
	hp_changed.emit(false, enemy_hp)
	check_battle_end()
	if current_state != BattleState.VICTORY:
		current_state = BattleState.ENEMY_TURN
		state_changed.emit(current_state)
		await get_tree().create_timer(1.0).timeout
		enemy_attack()

func enemy_attack() -> void:
	if current_state != BattleState.ENEMY_TURN:
		return
	var damage = 15
	player_hp = max(0, player_hp - damage)
	hp_changed.emit(true, player_hp)
	check_battle_end()
	if current_state != BattleState.DEFEAT:
		current_state = BattleState.PLAYER_TURN
		state_changed.emit(current_state)

func check_battle_end() -> void:
	if enemy_hp <= 0:
		end_battle(true)
	elif player_hp <= 0:
		end_battle(false)

func end_battle(victory: bool) -> void:
	var xp := 20 if victory else 0
	current_state = BattleState.VICTORY if victory else BattleState.DEFEAT
	state_changed.emit(current_state)
	if EventBus.has_signal("battle_ended"):
		EventBus.battle_ended.emit(victory, xp)
	if victory:
		EventBus.xp_gained.emit(xp, "battle_victory")
