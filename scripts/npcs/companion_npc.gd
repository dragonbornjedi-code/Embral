extends BaseNPC
## CompanionNPC — Base class for Companions (second avatars).

class_name CompanionNPC

@export var companion_name: String
@export var is_coop_active: bool = false

func _ready() -> void:
    super._ready()
    add_to_group("companion_npc")

func set_control(human_controlled: bool) -> void:
    is_coop_active = human_controlled
    # Logic for switching between AI/Player control
    pass
