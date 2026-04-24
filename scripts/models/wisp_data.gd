extends Resource
## WispData — Data class for a single Wisp instance.

class_name WispData

@export var wisp_id: String = ""
@export var element: String = ""
@export var nickname: String = ""
@export var level: int = 1
@export var xp: int = 0
@export var hp: int = 100
@export var max_hp: int = 100
@export var ability_slots: Array[String] = []
@export var is_active: bool = false

func to_dict() -> Dictionary:
	return {
		"wisp_id": wisp_id,
		"element": element,
		"nickname": nickname,
		"level": level,
		"xp": xp,
		"hp": hp,
		"max_hp": max_hp,
		"ability_slots": ability_slots,
		"is_active": is_active
	}

func from_dict(data: Dictionary) -> void:
	wisp_id = data.get("wisp_id", "")
	element = data.get("element", "")
	nickname = data.get("nickname", "")
	level = data.get("level", 1)
	xp = data.get("xp", 0)
	hp = data.get("hp", 100)
	max_hp = data.get("max_hp", 100)
	ability_slots = data.get("ability_slots", [])
	is_active = data.get("is_active", false)

func gain_xp(amount: int) -> bool:
	xp += amount
	# Level up logic (placeholder)
	if xp >= level * 100:
		level += 1
		xp = 0
		return true
	return false

func get_element_color() -> Color:
	# Using the map defined in manifest.yaml creature_system
	var colors = {
		"fire": Color("#FF6B1A"),
		"water": Color("#2E86C1"),
		"wind": Color("#AED6F1"),
		"earth": Color("#28B463"),
		"electric": Color("#F4D03F"),
		"light": Color("#FDFEFE"),
		"dark": Color("#6C3483")
	}
	return colors.get(element, Color.WHITE)
