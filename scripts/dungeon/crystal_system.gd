extends Node
## Element matchup multipliers for ability combat (rock–paper–scissors style).

func get_multiplier(attacker_element: String, defender_element: String) -> float:
	if attacker_element.is_empty() or defender_element.is_empty():
		return 1.0
	var atk := attacker_element.to_lower()
	var def := defender_element.to_lower()
	if atk == def:
		return 1.0
	var strong := {
		"fire": "wind",
		"wind": "earth",
		"earth": "water",
		"water": "fire",
		"electric": "water",
		"light": "dark",
		"dark": "light",
	}
	if strong.get(atk, "") == def:
		return 1.5
	var weak := {}
	for a in strong.keys():
		weak[strong[a]] = a
	if weak.get(atk, "") == def:
		return 0.75
	return 1.0


func get_advantage_text(attacker_element: String, defender_element: String) -> String:
	var m := get_multiplier(attacker_element, defender_element)
	if m > 1.01:
		return "It's super effective!"
	if m < 0.99:
		return "It's not very effective..."
	return ""
