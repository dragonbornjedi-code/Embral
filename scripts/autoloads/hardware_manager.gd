extends Node
## HardwareManager — Hardware detection autoload
## Detects ALL hardware ONCE at startup. Results cached forever.
## No other script detects hardware. They only READ from here.
## Pattern: if HardwareManager.has_ps5(): ...

# ═══════════════════════════════════════════
# TIER DEFINITIONS
# 0 = keyboard/mouse only (base, always complete)
# 1 = PS5 controller
# 2 = Wii hardware
# 3 = Smart home (HA Green)
# 4 = Arduino/ESP32/Pi gadgets
# ═══════════════════════════════════════════

var _detected: bool = false
var _tier: int = 0
var _has_ps5: bool = false
var _has_wii: bool = false
var _has_ha: bool = false
var _has_esp32: bool = false
var _has_arduino: bool = false
var _has_pi: bool = false

# HA config — set via user://config.json
var _ha_url: String = ""
var _ha_token: String = ""


func _ready() -> void:
	await get_tree().process_frame
	await _detect_all()


# ───────────────────────────────────────────
# PUBLIC API — Read only, never call detect
# ───────────────────────────────────────────

func get_tier() -> int:
	return _tier

func has_ps5() -> bool:
	return _has_ps5

func has_wii() -> bool:
	return _has_wii

func has_ha() -> bool:
	return _has_ha

func has_esp32() -> bool:
	return _has_esp32

func has_arduino() -> bool:
	return _has_arduino

func has_pi() -> bool:
	return _has_pi

func is_detected() -> bool:
	return _detected


# ───────────────────────────────────────────
# DETECTION — Runs once at startup
# ───────────────────────────────────────────

func _detect_all() -> void:
	_detect_controllers()
	_detect_wii()
	await _detect_ha()
	_detect_serial_devices()
	_tier = _calculate_tier()
	_detected = true
	EventBus.hardware_ready.emit(_tier)
	print("[HardwareManager] Detection complete. Tier: %d | PS5: %s | Wii: %s | HA: %s | ESP32: %s | Arduino: %s | Pi: %s" % [
		_tier, _has_ps5, _has_wii, _has_ha, _has_esp32, _has_arduino, _has_pi
	])


func _detect_controllers() -> void:
	for joy_id in Input.get_connected_joypads():
		var name := Input.get_joy_name(joy_id).to_lower()
		if "dualsense" in name or "ps5" in name or "playstation 5" in name:
			_has_ps5 = true
			EventBus.ps5_connected.emit()
			print("[HardwareManager] PS5 DualSense detected: joy_id=%d" % joy_id)


func _detect_wii() -> void:
	# Check /proc/bus/input/devices for Nintendo Wii Remote
	var file := FileAccess.open("/proc/bus/input/devices", FileAccess.READ)
	if file == null:
		return
	var content := file.get_as_text()
	file.close()
	if "Nintendo" in content and ("Wii" in content or "RVL" in content):
		_has_wii = true
		EventBus.wii_connected.emit()
		print("[HardwareManager] Wii hardware detected.")


func _detect_ha() -> void:
	# Load HA config from user://config.json
	var config: String = ConfigLoader.get_value("ha_url", "") if _config_loader_ready() else ""
	if config == "":
		return
	_ha_url = config
	_ha_token = ConfigLoader.get_secret("ha_token") if _config_loader_ready() else ""
	# Async ping — does not block game start
	var http := HTTPRequest.new()
	add_child(http)
	var err := http.request(_ha_url + "/api/", [], HTTPClient.METHOD_GET)
	if err != OK:
		http.queue_free()
		return
	var result: Array = await http.request_completed
	http.queue_free()
	var status_code: int = result[1]

	if status_code == 200 or status_code == 401:
		# 401 = HA is there but needs auth — still counts as online
		_has_ha = true
		EventBus.ha_online.emit()
		print("[HardwareManager] Home Assistant detected at %s" % _ha_url)
	else:
		print("[HardwareManager] HA ping failed (status %d). Offline mode." % status_code)


func _detect_serial_devices() -> void:
	# Scan /dev/ttyUSB* and /dev/ttyACM* for Arduino/ESP32
	var dir := DirAccess.open("/dev")
	if dir == null:
		return
	dir.list_dir_begin()
	var fname := dir.get_next()
	while fname != "":
		if "ttyUSB" in fname or "ttyACM" in fname:
			# Heuristic: ttyUSB = likely ESP32/Arduino
			_has_esp32 = true
			_has_arduino = true
			print("[HardwareManager] Serial device detected: /dev/%s" % fname)
		fname = dir.get_next()
	dir.list_dir_end()


func _calculate_tier() -> int:
	if _has_ha or _has_esp32 or _has_arduino or _has_pi:
		return 4
	if _has_wii:
		return 3
	if _has_ha:
		return 3
	if _has_ps5:
		return 1
	return 0


func _config_loader_ready() -> bool:
	return Engine.has_singleton("ConfigLoader") or get_node_or_null("/root/ConfigLoader") != null
