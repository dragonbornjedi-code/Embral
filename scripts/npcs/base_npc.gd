extends Node
## BaseNPC — Base class for all NPCs.

class_name BaseNPC

signal interaction_started(npc: BaseNPC)
signal interaction_ended(npc: BaseNPC)

@export var npc_id: String
@export var realm: String

func _ready() -> void:
    add_to_group("npc")

func interact() -> void:
    emit_signal("interaction_started", self)
    # Dialogue logic dispatch here
    print("Interacting with: ", npc_id)
    emit_signal("interaction_ended", self)
