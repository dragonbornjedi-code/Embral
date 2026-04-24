extends Resource
## NPCHomeData — NPC home preference data.
## Used for checking if an NPC's housing requirements are met.

class_name NPCHomeData

@export_group("Preferences")
@export var preferred_terrain: String = "grass" # e.g. "grass", "stone", "water"
@export var preferred_facing: Vector3 = Vector3.FORWARD
@export var proximity_radius: float = 10.0
@export var proximity_preferences: Array[String] = [] # List of realm IDs or building IDs


func validate(_current_scene: Node) -> bool:
	## Stub for validation logic. Returns true if all preferences are met.
	## In a full implementation, this would scan the scene for terrain and buildings.
	return true
