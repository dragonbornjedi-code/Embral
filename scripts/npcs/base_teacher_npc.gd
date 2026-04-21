extends BaseNPC
## BaseTeacherNPC — Base class for all Teacher NPCs.

class_name BaseTeacherNPC

@export var subject: String
@export var mastery_level: int = 0

func _ready() -> void:
    super._ready()
    add_to_group("teacher_npc")

func get_available_quests() -> Array:
    # Quest catalogue lookup logic
    return []
