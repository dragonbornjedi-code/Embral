extends Node
class_name AbilitySystem

const ABILITIES = {
    "fire_blast": {"name": "Fire Blast", "dmg": 20, "element": "fire"},
    "aqua_shield": {"name": "Aqua Shield", "dmg": 0, "element": "water"},
    "earth_shake": {"name": "Earth Shake", "dmg": 15, "element": "earth"}
}

func get_ability_data(id: String) -> Dictionary:
    return ABILITIES.get(id, {})
