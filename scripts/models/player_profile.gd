extends Resource
class_name PlayerProfile

## PlayerProfile — Data class for player state.
## Stores level, XP, gold, and other progression metrics.

@export var profile_id: String = ""
@export var player_name: String = "Ezra"
@export var level: int = 1
@export var xp: int = 0
@export var gold: int = 0
@export var raid_points: int = 0
@export var play_points: int = 0
@export var last_realm: String = "realm_0" # Hearthveil
@export var quest_completion: Dictionary = {} # quest_id -> {score, timestamp}
@export var created_at: int = 0
@export var last_played_at: int = 0

func _init() -> void:
	created_at = int(Time.get_unix_time_from_system())
	last_played_at = created_at

func to_dict() -> Dictionary:
	return {
		"profile_id": profile_id,
		"player_name": player_name,
		"level": level,
		"xp": xp,
		"gold": gold,
		"raid_points": raid_points,
		"play_points": play_points,
		"last_realm": last_realm,
		"quest_completion": quest_completion,
		"created_at": created_at,
		"last_played_at": last_played_at
	}

static func from_dict(dict: Dictionary):
	var profile = new()
	profile.profile_id = dict.get("profile_id", "")
	profile.player_name = dict.get("player_name", "Ezra")
	profile.level = dict.get("level", 1)
	profile.xp = dict.get("xp", 0)
	profile.gold = dict.get("gold", 0)
	profile.raid_points = dict.get("raid_points", 0)
	profile.play_points = dict.get("play_points", 0)
	profile.last_realm = dict.get("last_realm", "realm_0")
	profile.quest_completion = dict.get("quest_completion", {})
	profile.created_at = dict.get("created_at", 0)
	profile.last_played_at = dict.get("last_played_at", 0)
	return profile
