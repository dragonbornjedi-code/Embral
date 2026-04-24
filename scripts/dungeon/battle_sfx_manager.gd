extends Node
## BattleSFXManager — Handles battle-related audio and particles.

func _ready() -> void:
    EventBus.battle_started.connect(_on_battle_started)
    EventBus.sfx_requested.connect(_on_sfx_requested)

func _on_battle_started(_p: String, _e: String) -> void:
    EventBus.sfx_requested.emit("battle_start", Vector3.ZERO)

func _on_sfx_requested(sfx_name: String, _pos: Vector3) -> void:
    # Integration with AudioSystem would go here
    print("[SFX] Playing: ", sfx_name)
