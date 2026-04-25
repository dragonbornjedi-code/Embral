extends Node
## HABridge — ONLY file that communicates with Home Assistant
## All other scripts call HABridge methods. None call HA directly.
## Circuit breaker built in — returns null gracefully when offline.
## Safe Mode: set ha_safe_mode=true in user://config.json to disable all HA calls.

var _is_online: bool = false
var _safe_mode: bool = false
var _base_url: String = ""
var _token: String = ""
var _consecutive_failures: int = 0
const FAILURE_THRESHOLD: int = 3

func set_realm_lights(realm_id: String) -> void:
	if not HardwareManager.has_ha():
		return
	var colors = {
		"realm_1": {"r": 255, "g": 80, "b": 25},
		"realm_2": {"r": 25, "g": 130, "b": 255},
		"realm_3": {"r": 180, "g": 200, "b": 255},
		"realm_4": {"r": 50, "g": 180, "b": 50},
		"realm_5": {"r": 255, "g": 230, "b": 25},
		"realm_6": {"r": 200, "g": 100, "b": 255}
	}
	var color = colors.get(realm_id, {"r": 255, "g": 255, "b": 255})
	_call_ha("light.turn_on", {"entity_id": "light.game_room", "rgb_color": [color.r, color.g, color.b]})

func _call_ha(service: String, data: Dictionary) -> void:
	if _safe_mode or not HardwareManager.has_ha():
		return
	var ha_url = OS.get_environment("HASS_SERVER")
	var ha_token = OS.get_environment("HASS_TOKEN")
	if ha_url == "" or ha_token == "":
		push_warning("[HABridge] HA credentials not set")
		return
	var http = HTTPRequest.new()
	add_child(http)
	var parts = service.split(".")
	var url = "%s/api/services/%s/%s" % [ha_url, parts[0], parts[1]]
	var headers = ["Authorization: Bearer %s" % ha_token, "Content-Type: application/json"]
	http.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(data))

func _ready() -> void:
	EventBus.ha_online.connect(_on_ha_online)
	EventBus.ha_offline.connect(_on_ha_offline)
	if EventBus.has_signal("realm_unlocked"):
		EventBus.realm_unlocked.connect(set_realm_lights)
	_safe_mode = ConfigLoader.get_value("ha_safe_mode", false)
	if _safe_mode:
		push_warning("[HABridge] Safe Mode active — all Home Assistant calls disabled.")


# ───────────────────────────────────────────
# PUBLIC API
# ───────────────────────────────────────────

func is_online() -> bool:
	return _is_online and not _safe_mode

func is_safe_mode() -> bool:
	return _safe_mode

## Enable safe mode at runtime (e.g. after repeated failures or user preference)
func enable_safe_mode() -> void:
	_safe_mode = true
	_is_online = false
	push_warning("[HABridge] Safe Mode enabled — HA integration suspended.")


## Trigger a light effect by name
## Returns null silently if HA offline or safe mode active
func trigger_light_effect(effect_name: String) -> void:
	if _safe_mode or not _is_online:
		return
	await _post("/api/services/script/turn_on", {"entity_id": "script." + effect_name})


## Trigger a celebration sequence
func celebrate(intensity: String = "normal") -> void:
	if _safe_mode or not _is_online:
		return
	await trigger_light_effect("embral_celebrate_" + intensity)


## Set room lights to realm color
func set_realm_color(realm_id: String) -> void:
	if _safe_mode or not _is_online:
		return
	await trigger_light_effect("embral_realm_" + realm_id)


## Fire a webhook event (for quest completion, etc.)
func fire_webhook(event_id: String, data: Dictionary = {}) -> void:
	if _safe_mode or not _is_online:
		return
	await _post("/api/webhook/" + event_id, data)


# ───────────────────────────────────────────
# INTERNAL — Circuit breaker pattern
# ───────────────────────────────────────────

func _post(endpoint: String, data: Dictionary) -> Variant:
	if not _is_online:
		return null
	var http := HTTPRequest.new()
	add_child(http)
	var headers := [
		"Content-Type: application/json",
		"Authorization: Bearer " + _token
	]
	var body := JSON.stringify(data)
	var err := http.request(_base_url + endpoint, headers, HTTPClient.METHOD_POST, body)
	if err != OK:
		http.queue_free()
		_register_failure()
		return null
	var result: Array = await http.request_completed
	http.queue_free()
	var status: int = result[1]

	if status >= 400:
		_register_failure()
		return null
	_consecutive_failures = 0
	return result[3]


func _register_failure() -> void:
	_consecutive_failures += 1
	if _consecutive_failures >= FAILURE_THRESHOLD:
		_is_online = false
		EventBus.ha_offline.emit()
		push_warning("[HABridge] Circuit breaker open — HA marked offline after %d failures." % _consecutive_failures)


func _on_ha_online() -> void:
	_is_online = true
	_consecutive_failures = 0
	_base_url = ConfigLoader.get_value("ha_url", "")
	_token = ConfigLoader.get_secret("ha_token")


func _on_ha_offline() -> void:
	_is_online = false
