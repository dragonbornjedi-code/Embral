extends Node
## DialogicStub — Circuit-breaker stub for Dialogic 2.
## When Dialogic is not installed, reads fallback dialogue from
## data/dialogue/{npc_id}_fallback.json.
##
## Exposes a minimal API so NPC scripts work without branching:
##   DialogicStub.start_timeline(npc_id)   → plays timeline or fallback
##   DialogicStub.get_fallback_line(npc_id) → returns a fallback string
##
## To install real Dialogic 2:
##   1. Download from https://github.com/dialogic-godot/dialogic/releases
##   2. Place in addons/dialogic/
##   3. Enable in Project → Project Settings → Plugins
##   4. Update compatibility.md with the installed version.
##   5. Replace calls to DialogicStub with Dialogic.start() as appropriate.

const DIALOGIC_PLUGIN_PATH := "res://addons/dialogic/plugin.cfg"
const FALLBACK_BASE := "res://data/dialogue/"

var _dialogic_available: bool = false
var _fallback_cache: Dictionary = {}


func _ready() -> void:
	_dialogic_available = FileAccess.file_exists(DIALOGIC_PLUGIN_PATH)
	if _dialogic_available:
		print("[DialogicStub] Dialogic 2 detected. Real integration needed.")
	else:
		push_warning("[DialogicStub] Dialogic 2 not installed. Fallback dialogue active.")


func is_available() -> bool:
	return _dialogic_available


## Start a dialogue timeline for an NPC.
## Falls back to printing a fallback line if Dialogic is missing.
## Returns the fallback line string (or "" if Dialogic handled it).
func start_timeline(npc_id: String) -> String:
	if _dialogic_available:
		# Real Dialogic call would go here:
		# Dialogic.start(npc_id)
		push_warning("[DialogicStub] Dialogic present but not wired. Falling back.")
	return get_fallback_line(npc_id)


## Get a single fallback dialogue line for an NPC.
## Returns a generic line if no fallback file exists.
func get_fallback_line(npc_id: String) -> String:
	var lines := _load_fallback(npc_id)
	if lines.is_empty():
		return "..."
	# Rotate through lines based on time to avoid always showing the first
	var idx := int(Time.get_unix_time_from_system()) % lines.size()
	return lines[idx]


## Get the "no active quest" line for an NPC.
func get_no_quest_line(npc_id: String) -> String:
	var data := _load_fallback_data(npc_id)
	return data.get("no_quest_line", "Come back when you're ready for a new adventure!")


func _load_fallback(npc_id: String) -> Array:
	var data := _load_fallback_data(npc_id)
	return data.get("lines", [])


func _load_fallback_data(npc_id: String) -> Dictionary:
	if _fallback_cache.has(npc_id):
		return _fallback_cache[npc_id]
	var path := FALLBACK_BASE + npc_id + "_fallback.json"
	if not FileAccess.file_exists(path):
		push_warning("[DialogicStub] No fallback file for NPC: %s (expected: %s)" % [npc_id, path])
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("[DialogicStub] Could not open fallback file: %s" % path)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if parsed == null or not parsed is Dictionary:
		push_error("[DialogicStub] Invalid JSON in fallback file: %s" % path)
		return {}
	_fallback_cache[npc_id] = parsed
	return parsed
