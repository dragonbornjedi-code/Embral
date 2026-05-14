extends Resource
## PlayerProfile — Data class for player state.

class_name PlayerProfile

@export var profile_id: String = ""
@export var player_name: String = "Explorer"
@export var level: int = 1
@export var xp: int = 0
@export var xp_to_next_level: int = 100
@export var gold: int = 0
@export var raid_points: int = 0
@export var play_points: int = 0
@export var quest_completion: Dictionary = {} # quest_id -> {score, timestamp}
@export var realm_seals: Array[String] = []
@export var created_at: int = 0
@export var active_wisp_slots: Array[String] = []
@export var companion_id: String = ""
@export var total_play_time_seconds: int = 0
@export var last_played_timestamp: int = 0
@export var created_timestamp: int = 0
@export var avatar_color: String = "blue"
@export var avatar_style: String = "explorer"
@export var tutorial_completed: bool = false
@export var tutorial_intro_completed: bool = false
@export var tutorial_realms_completed: Array[String] = []
@export var house_unlocked: bool = false
@export var pet_unlocked: bool = false
@export var first_pet_id: String = ""

func to_dict() -> Dictionary:
	return {
		"profile_id": profile_id,
		"player_name": player_name,
		"level": level,
		"xp": xp,
		"xp_to_next_level": xp_to_next_level,
		"gold": gold,
		"raid_points": raid_points,
		"play_points": play_points,
		"quest_completion": quest_completion,
		"realm_seals": realm_seals,
		"active_wisp_slots": active_wisp_slots,
		"companion_id": companion_id,
		"total_play_time_seconds": total_play_time_seconds,
		"last_played_timestamp": last_played_timestamp,
		"created_timestamp": created_timestamp,
		"avatar_color": avatar_color,
		"avatar_style": avatar_style,
		"tutorial_completed": tutorial_completed,
		"tutorial_intro_completed": tutorial_intro_completed,
		"tutorial_realms_completed": tutorial_realms_completed,
		"house_unlocked": house_unlocked,
		"pet_unlocked": pet_unlocked,
		"first_pet_id": first_pet_id
	}

static func from_dict(data: Dictionary) -> PlayerProfile:
	var profile = PlayerProfile.new()
	profile.profile_id = data.get("profile_id", "")
	profile.player_name = data.get("player_name", "Explorer")
	profile.level = data.get("level", 1)
	profile.xp = data.get("xp", 0)
	profile.xp_to_next_level = data.get("xp_to_next_level", 100)
	profile.gold = data.get("gold", 0)
	profile.raid_points = data.get("raid_points", 0)
	profile.play_points = data.get("play_points", 0)
	profile.quest_completion = data.get("quest_completion", {})
	profile.realm_seals = _string_array_from(data.get("realm_seals", []))
	profile.active_wisp_slots = _string_array_from(data.get("active_wisp_slots", []))
	profile.companion_id = data.get("companion_id", "")
	profile.total_play_time_seconds = data.get("total_play_time_seconds", 0)
	# Legacy key was last_played_at (rename drift vs save_manager)
	profile.last_played_timestamp = int(
		data.get("last_played_timestamp", data.get("last_played_at", 0))
	)
	profile.created_timestamp = int(
		data.get("created_timestamp", data.get("created_at", 0))
	)
	profile.avatar_color = data.get("avatar_color", "blue")
	profile.avatar_style = data.get("avatar_style", "explorer")
	profile.tutorial_completed = bool(data.get("tutorial_completed", false))
	profile.tutorial_intro_completed = bool(data.get("tutorial_intro_completed", false))
	profile.tutorial_realms_completed = _string_array_from(data.get("tutorial_realms_completed", []))
	profile.house_unlocked = bool(data.get("house_unlocked", false))
	profile.pet_unlocked = bool(data.get("pet_unlocked", false))
	profile.first_pet_id = data.get("first_pet_id", "")
	return profile


static func _string_array_from(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if value is Array:
		for item in value:
			result.append(str(item))
	return result

func gain_xp(amount: int) -> bool:
	xp += amount
	if xp >= xp_to_next_level:
		level_up()
		return true
	return false

func level_up() -> void:
	level += 1
	xp = 0
	xp_to_next_level = int(100 * level * 1.2)
