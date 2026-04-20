extends Node
## HABridge — ONLY file that communicates with Home Assistant
## All other scripts call HABridge methods. None call HA directly.
## Circuit breaker built in — returns null gracefully when offline.

var _is_online: bool = false
var _base_url: String = ""
var _token: String = ""
var _consecutive_failures: int = 0
const FAILURE_THRESHOLD: int = 3

func _ready() -> void:
	EventBus.ha_online.connect(_on_ha_online)
	EventBus.ha_offline.connect(_on_ha_offline)


# ───────────────────────────────────────────
# PUBLIC API
# ───────────────────────────────────────────

func is_online() -> bool:
	return _is_online


## Trigger a light effect by name
## Returns null silently if HA offline
func trigger_light_effect(effect_name: String) -> void:
	if not _is_online:
		return
	await _post("/api/services/script/turn_on", {"entity_id": "script." + effect_name})


## Trigger a celebration sequence
func celebrate(intensity: String = "normal") -> void:
	if not _is_online:
		return
	await trigger_light_effect("embral_celebrate_" + intensity)


## Set room lights to realm color
func set_realm_color(realm_id: String) -> void:
	if not _is_online:
		return
	await trigger_light_effect("embral_realm_" + realm_id)


## Fire a webhook event (for quest completion, etc.)
func fire_webhook(event_id: String, data: Dictionary = {}) -> void:
	if not _is_online:
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
	var result := await http.request_completed
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
