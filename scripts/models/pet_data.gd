extends Resource
## PetData — Data class for a single Pet instance.

class_name PetData

@export var pet_id: String = ""
@export var species: String = ""
@export var nickname: String = ""
@export var happiness: int = 50
@export var hunger: int = 50
@export var level: int = 1
@export var last_fed_timestamp: int = 0
@export var passive_bonus_type: String = ""
@export var passive_bonus_value: float = 0.0

func to_dict() -> Dictionary:
	return {
		"pet_id": pet_id,
		"species": species,
		"nickname": nickname,
		"happiness": happiness,
		"hunger": hunger,
		"level": level,
		"last_fed_timestamp": last_fed_timestamp,
		"passive_bonus_type": passive_bonus_type,
		"passive_bonus_value": passive_bonus_value
	}

func from_dict(data: Dictionary) -> void:
	pet_id = data.get("pet_id", "")
	species = data.get("species", "")
	nickname = data.get("nickname", "")
	happiness = data.get("happiness", 50)
	hunger = data.get("hunger", 50)
	level = data.get("level", 1)
	last_fed_timestamp = data.get("last_fed_timestamp", 0)
	passive_bonus_type = data.get("passive_bonus_type", "")
	passive_bonus_value = data.get("passive_bonus_value", 0.0)

func tick_hunger() -> void:
	hunger = max(0, hunger - 5)

func get_happiness_label() -> String:
	if happiness >= 80: return "Happy"
	if happiness >= 40: return "Content"
	return "Sad"
