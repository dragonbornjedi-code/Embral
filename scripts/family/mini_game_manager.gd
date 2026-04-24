extends Node
class_name MiniGameManager

const MINI_GAMES: Array[String] = [
    "wisp_match",
    "word_catch", 
    "number_race",
    "emotion_sort",
    "letter_bounce"
]

func launch_game(game_id: String) -> void:
    var path = "res://scenes/minigames/%s.tscn" % game_id
    if ResourceLoader.exists(path):
        TransitionManager.change_scene(path)
    else:
        push_error("[MiniGameManager] Scene not found: %s" % path)

func get_available_games() -> Array[String]:
    return MINI_GAMES
