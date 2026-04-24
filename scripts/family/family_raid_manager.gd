extends Node
class_name FamilyRaidManager

const RAID_TYPES: Array[String] = [
    "nature_walk",
    "cooking_together", 
    "game_night",
    "reading_session",
    "exercise_challenge",
    "art_project",
    "community_helper",
    "failure_acceptance"
]

var current_raid: String = ""
var raid_active: bool = false

func check_raid_trigger() -> bool:
    if SaveManager.active_profile == null: return false
    return SaveManager.get_raid_points() >= 3

func start_raid() -> void:
    current_raid = RAID_TYPES[randi() % RAID_TYPES.size()]
    raid_active = true
    EventBus.sfx_requested.emit("raid_start", Vector3.ZERO)

func complete_raid() -> void:
    raid_active = false
    # Reset raid points in the actual profile object
    if SaveManager.active_profile:
        SaveManager.active_profile.raid_points = 0
    EventBus.xp_gained.emit(100, "family_raid")
    EventBus.gold_gained.emit(50, "family_raid")
