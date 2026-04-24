extends Node
## CrystalSystem — Type effectiveness logic.

class_name CrystalSystem

const ELEMENT_TYPES = ["fire", "water", "wind", "earth", "electric", "light", "dark"]

const EFFECTIVENESS = {
	"fire": {"wind": 1.5, "water": 0.75},
	"wind": {"earth": 1.5, "fire": 0.75},
	"earth": {"water": 1.5, "wind": 0.75},
	"water": {"fire": 1.5, "electric": 0.75},
	"electric": {"water": 1.5},
	"light": {"dark": 1.5},
	"dark": {"light": 1.5}
}

func get_multiplier(attacker: String, defender: String) -> float:
	if attacker in EFFECTIVENESS and defender in EFFECTIVENESS[attacker]:
		return EFFECTIVENESS[attacker][defender]
	return 1.0

func get_advantage_text(attacker: String, defender: String) -> String:
	var mult = get_multiplier(attacker, defender)
	if mult > 1.0:
		return "Super Effective!"
	elif mult < 1.0:
		return "Not Very Effective..."
	return ""
