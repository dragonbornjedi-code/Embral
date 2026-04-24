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
		"created_timestamp": created_timestamp
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
	profile.realm_seals = data.get("realm_seals", [])
	profile.active_wisp_slots = data.get("active_wisp_slots", [])
	profile.companion_id = data.get("companion_id", "")
	profile.total_play_time_seconds = data.get("total_play_time_seconds", 0)
	profile.last_played_timestamp = data.get("last_played_timestamp", 0)
	profile.created_timestamp = data.get("created_timestamp", 0)
	return profile
	raid_points = data.get("raid_points", 0)
	play_points = data.get("play_points", 0)
	quest_completion = data.get("quest_completion", {})
	realm_seals = data.get("realm_seals", [])
	active_wisp_slots = data.get("active_wisp_slots", [])
	companion_id = data.get("companion_id", "")
	total_play_time_seconds = data.get("total_play_time_seconds", 0)
	last_played_timestamp = data.get("last_played_timestamp", 0)
	created_timestamp = data.get("created_timestamp", 0)

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
