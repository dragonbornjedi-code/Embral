extends Node
class_name NightlyReview

signal review_completed(raid_point_awarded: bool)

var _ignavarr_lines: Array[String] = [
    "What was the best part of your adventure today, {player}?",
    "Did you help anyone in the realms today?",
    "What felt hard today? That's how we grow!",
    "Tell me one thing you learned on your journey!",
    "You were so brave today, {player}. What made you proud?"
]

func start_review(player_name: String) -> void:
    # Logic: Pick random question, display UI, wait for interaction
    var question = _ignavarr_lines.pick_random().replace("{player}", player_name)
    print("Nightly Review: ", question)
    # UI implementation (Panel + Label + Button) handled via UI system
    # This logic emits review_completed(false) initially

func _award_raid_point() -> void:
    if SaveManager.active_profile != null:
        SaveManager.active_profile.raid_points += 1
        EventBus.xp_gained.emit(25, "nightly_review")
        emit_signal("review_completed", true)
