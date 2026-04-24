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
const DIALOGIC_TIMELINE_SCRIPT := "res://addons/dialogic/Resources/timeline.gd"
const FALLBACK_BASE := "res://data/dialogue/"

var _dialogic_available: bool = false
var _fallback_cache: Dictionary = {}


func _ready() -> void:
	_dialogic_available = FileAccess.file_exists(DIALOGIC_PLUGIN_PATH) and get_node_or_null("/root/Dialogic") != null
	if _dialogic_available:
		print("[DialogicStub] Dialogic 2 detected. Real timeline bridge active.")
	else:
		push_warning("[DialogicStub] Dialogic 2 not installed. Fallback dialogue active.")


func is_available() -> bool:
	return _dialogic_available


## Start a dialogue timeline for an NPC.
## Falls back to returning a fallback line if Dialogic is missing or launch fails.
## Returns the fallback line string (or "" if Dialogic handled it).
func start_timeline(npc_id: String) -> String:
	var line := get_fallback_line(npc_id)
	if _dialogic_available and _start_dialogic_timeline(npc_id, line):
		return ""
	if _dialogic_available:
		push_warning("[DialogicStub] Dialogic present but timeline launch failed. Falling back.")
	return line


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


func _start_dialogic_timeline(npc_id: String, line: String) -> bool:
	var dialogic := get_node_or_null("/root/Dialogic")
	if dialogic == null:
		return false

	var timeline_script: Script = load(DIALOGIC_TIMELINE_SCRIPT)
	if timeline_script == null:
		return false

	var timeline: Resource = timeline_script.new()
	var text := line.strip_edges()
	if text.is_empty():
		text = "..."

	timeline.from_text(_build_timeline_text(npc_id, text))
	dialogic.start(timeline)
	return true


func _build_timeline_text(npc_id: String, line: String) -> String:
	var player_name = "Explorer"
	if SaveManager.active_profile:
		player_name = SaveManager.active_profile.player_name
	
	var final_line = line.replace("{player}", player_name)
	return '%s says: %s' % [_prettify_npc_id(npc_id), final_line.replace("\n", " ")]


func _prettify_npc_id(npc_id: String) -> String:
	var words := npc_id.split("_", false)
	var parts: Array[String] = []
	for word in words:
		if word.is_empty():
			continue
		parts.append(word.substr(0, 1).to_upper() + word.substr(1))
	return " ".join(parts) if not parts.is_empty() else "Guide"


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
