extends CanvasLayer
## WispBattleUI — Visual interface for turn-based combat.

@onready var player_hp_bar = %PlayerHP
@onready var enemy_hp_bar = %EnemyHP
@onready var action_grid = %ActionGrid
@onready var feedback_label = %FeedbackLabel

var battle_logic: WispBattle

func open(logic: WispBattle) -> void:
	battle_logic = logic
	battle_logic.state_changed.connect(_on_state_changed)
	battle_logic.hp_changed.connect(_on_hp_changed)
	show()

func _on_state_changed(state: WispBattle.BattleState) -> void:
	match state:
		WispBattle.BattleState.PLAYER_TURN:
			action_grid.show()
			feedback_label.text = "Your turn!"
		WispBattle.BattleState.ENEMY_TURN:
			action_grid.hide()
			feedback_label.text = "Enemy is attacking..."
		WispBattle.BattleState.VICTORY:
			feedback_label.text = "Victory!"
			await get_tree().create_timer(2.0).timeout
			hide()
		WispBattle.BattleState.DEFEAT:
			feedback_label.text = "Defeat!"
			await get_tree().create_timer(2.0).timeout
			hide()

func _on_hp_changed(is_player: bool, new_hp: int) -> void:
	if is_player:
		player_hp_bar.value = new_hp
	else:
		enemy_hp_bar.value = new_hp
