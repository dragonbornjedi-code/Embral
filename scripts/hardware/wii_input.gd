extends Node
class_name WiiInput

var wiimote_connected: bool = false
var balance_board_connected: bool = false

func _ready() -> void:
    if not HardwareManager.has_wii():
        return
    _detect_devices()

func _detect_devices() -> void:
    var devices = []
    # Simplified device detection for white-box
    if FileAccess.file_exists("/proc/bus/input/devices"):
        var f = FileAccess.open("/proc/bus/input/devices", FileAccess.READ)
        var content = f.get_as_text()
        f.close()
        wiimote_connected = "Nintendo Wii" in content
        balance_board_connected = "Balance Board" in content
    
    print("[WiiInput] Wiimote: %s | Balance Board: %s" % [wiimote_connected, balance_board_connected])

func get_balance_center() -> Vector2:
    if not balance_board_connected:
        return Vector2.ZERO
    # Mock balance data
    return Vector2.ZERO

func is_wiimote_connected() -> bool:
    return wiimote_connected

## Helper for expansion
func get_device_info() -> Dictionary:
    return {
        "wiimote": wiimote_connected,
        "balance_board": balance_board_connected,
        "timestamp": Time.get_unix_time_from_system()
    }
