extends Node
class_name WispBattleManager

var active_battle: WispBattle
var battle_ui: WispBattleUI

func start_battle(player_id: String, enemy_id: String, ui: WispBattleUI) -> void:
    active_battle = WispBattle.new()
    add_child(active_battle)
    battle_ui = ui
    battle_ui.open(active_battle)
    active_battle.start_battle(player_id, enemy_id)
