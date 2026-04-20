extends Node
## ConfigLoader — Loads user://config.json
## Player preferences, hardware URLs, display settings.
## Secrets (tokens, IPs) loaded via secret-tool at runtime — never stored in config.

const CONFIG_PATH := "user://config.json"

var _config: Dictionary = {}


func _ready() -> void:
	_load()


func _load() -> void:
	if not FileAccess.file_exists(CONFIG_PATH):
		_config = _default_config()
		_save()
		return
	var file := FileAccess.open(CONFIG_PATH, FileAccess.READ)
	if file == null:
		push_error("[ConfigLoader] Could not open config file.")
		_config = _default_config()
		return
	var text := file.get_as_text()
	file.close()
	var parsed: Variant = JSON.parse_string(text)
	if parsed == null or not parsed is Dictionary:
		push_error("[ConfigLoader] Config file is invalid JSON. Using defaults.")
		_config = _default_config()
		return
	_config = parsed


func _save() -> void:
	var file := FileAccess.open(CONFIG_PATH, FileAccess.WRITE)
	if file == null:
		push_error("[ConfigLoader] Could not write config file.")
		return
	file.store_string(JSON.stringify(_config, "\t"))
	file.close()


## Get a config value with fallback default
func get_value(key: String, default: Variant = null) -> Variant:
	return _config.get(key, default)


## Set a config value and save
func set_value(key: String, value: Variant) -> void:
	_config[key] = value
	_save()


## Get a secret from secret-tool (never from config file)
## secret-tool lookup embral {key}
func get_secret(key: String) -> String:
	var output := []
	var exit := OS.execute("secret-tool", ["lookup", "embral", key], output, true)
	if exit != 0:
		push_warning("[ConfigLoader] Secret not found for key: %s" % key)
		return ""
	return output[0].strip_edges()


func _default_config() -> Dictionary:
	return {
		"ha_url": "",
		"ha_safe_mode": false,
		"display_name": "Explorer",
		"parent_pin": "",
		"checkin_mode": "face_selector",
		"master_volume": 1.0,
		"music_volume": 0.8,
		"sfx_volume": 1.0,
		"fullscreen": false,
		"active_profile": ""
	}
