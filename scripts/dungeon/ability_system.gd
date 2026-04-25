extends Node
class_name AbilitySystem

const ABILITIES = {
    "fire_blast": {"name": "Fire Blast", "dmg": 20, "element": "fire"},
    "aqua_shield": {"name": "Aqua Shield", "dmg": 0, "element": "water"},
    "earth_shake": {"name": "Earth Shake", "dmg": 15, "element": "earth"}
}

func get_ability_data(id: String) -> Dictionary:
	return ABILITIES.get(id, {})

func get_ability_effect(id: String, attacker: WispData, defender: WispData) -> Dictionary:
    var ability = get_ability_data(id)
    if ability.is_empty(): return {"type": "none", "value": 0}
    
    var mult = crystal_system.get_multiplier(ability.element, defender.element)
    var val = int(ability.get("dmg", 0) * mult)
    
    return {"type": "damage", "value": val, "text": crystal_system.get_advantage_text(ability.element, defender.element)}
