extends Node
## PS5Input — Handles DualSense Haptic Feedback and LED feedback.

class_name PS5Input

signal haptic_triggered(intensity: float, duration: float)

func _ready() -> void:
    if not HardwareManager.has_ps5():
        return
    EventBus.battle_started.connect(_on_battle_started)
    EventBus.xp_gained.connect(_on_xp_gained)

## Trigger vibration on the DualSense controller
func trigger_haptic(intensity: float, duration: float) -> void:
    if not HardwareManager.has_ps5():
        return
    haptic_triggered.emit(intensity, duration)
    # The DualSense requires strong/weak motor settings
    # We map intensity to both motors for a consistent effect
    Input.start_joy_vibration(0, intensity, intensity, duration)

## Helper to stop all vibration immediately
func stop_haptic() -> void:
    if HardwareManager.has_ps5():
        Input.stop_joy_vibration(0)

func _on_battle_started(_p: String, _e: String) -> void:
    trigger_haptic(0.8, 0.3)

func _on_xp_gained(_amount: int, _source: String) -> void:
    trigger_haptic(0.3, 0.1)

## Set the light bar color on the DualSense controller
func set_led_color(color: Color) -> void:
    if not HardwareManager.has_ps5():
        return
    pass # set_joy_led not available in Godot 4

## Maps realm identifier to controller LED color
func set_realm_color(realm_id: String) -> void:
    var colors = {
        "realm_1": Color(1.0, 0.3, 0.1),
        "realm_2": Color(0.1, 0.5, 1.0),
        "realm_3": Color(0.7, 0.8, 1.0),
        "realm_4": Color(0.2, 0.7, 0.2),
        "realm_5": Color(1.0, 0.9, 0.1),
        "realm_6": Color(0.8, 0.4, 1.0)
    }
    set_led_color(colors.get(realm_id, Color.WHITE))
