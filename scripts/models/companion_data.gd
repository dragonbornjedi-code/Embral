extends Resource
## CompanionData — Data class for a Companion instance.

class_name CompanionData

@export var companion_id: String = ""
@export var player_given_name: String = "Companion"
@export var appearance_preset: int = 0
@export var level: int = 1
@export var xp: int = 0
@export var wisp_slots: Array[String] = []
@export var is_traveling: bool = false

func to_dict() -> Dictionary:
	return {
		"companion_id": companion_id,
		"player_given_name": player_given_name,
		"appearance_preset": appearance_preset,
		"level": level,
		"xp": xp,
		"wisp_slots": wisp_slots,
		"is_traveling": is_traveling
	}

func from_dict(data: Dictionary) -> void:
	companion_id = data.get("companion_id", "")
	player_given_name = data.get("player_given_name", "Companion")
	appearance_preset = data.get("appearance_preset", 0)
	level = data.get("level", 1)
	xp = data.get("xp", 0)
	wisp_slots = data.get("wisp_slots", [])
	is_traveling = data.get("is_traveling", false)
