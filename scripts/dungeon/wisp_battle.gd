extends Node
## WispBattle — Turn-based battle controller logic.

class_name WispBattle

enum BattleState {PLAYER_TURN, ENEMY_TURN, VICTORY, DEFEAT}

signal state_changed(new_state: BattleState)
signal hp_changed(is_player: bool, new_hp: int)

var player_hp: int = 100
var enemy_hp: int = 100
var current_state: BattleState = BattleState.PLAYER_TURN

func start_battle(p_id: String, e_id: String) -> void:
	current_state = BattleState.PLAYER_TURN
	EventBus.battle_started.emit(p_id, e_id)
	state_changed.emit(current_state)

func player_attack(attacker_element: String, defender_element: String) -> void:
	if current_state != BattleState.PLAYER_TURN: return
	
	var mult = CrystalSystem.get_multiplier(attacker_element, defender_element)
	var dmg = int(20 * mult)
	enemy_hp = max(0, enemy_hp - dmg)
	
	hp_changed.emit(false, enemy_hp)
	
	if enemy_hp <= 0:
		end_battle(true)
	else:
		current_state = BattleState.ENEMY_TURN
		state_changed.emit(current_state)
		# Delay enemy turn for UX
		await get_tree().create_timer(1.0).timeout
		enemy_attack()

func enemy_attack() -> void:
	# Simple enemy logic: flat damage
	player_hp = max(0, player_hp - 15)
	hp_changed.emit(true, player_hp)
	
	if player_hp <= 0:
		end_battle(false)
	else:
		current_state = BattleState.PLAYER_TURN
		state_changed.emit(current_state)

func end_battle(victory: bool) -> void:
	if victory:
		current_state = BattleState.VICTORY
		EventBus.xp_gained.emit(50, "battle_victory")
	else:
		current_state = BattleState.DEFEAT
	state_changed.emit(current_state)
	EventBus.battle_ended.emit(victory)
