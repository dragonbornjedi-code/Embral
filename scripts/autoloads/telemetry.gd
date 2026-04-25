extends Node
class_name Telemetry

const TELEMETRY_PATH = "user://logs/telemetry.json"
var _session_start: int = 0
var _events: Array = []

func _ready() -> void:
	_session_start = Time.get_unix_time_from_system()
	DirAccess.make_dir_recursive_absolute("user://logs")
	EventBus.quest_completed.connect(_on_quest_completed)
	EventBus.xp_gained.connect(_on_xp_gained)
	EventBus.dungeon_completed.connect(_on_dungeon_completed)

func track(event_name: String, data: Dictionary = {}) -> void:
	var entry = {
		"event": event_name,
		"timestamp": Time.get_unix_time_from_system(),
		"session_time": Time.get_unix_time_from_system() - _session_start,
		"data": data
	}
	_events.append(entry)
	if _events.size() >= 10:
		_flush()

func _flush() -> void:
	var existing = []
	if FileAccess.file_exists(TELEMETRY_PATH):
		var f = FileAccess.open(TELEMETRY_PATH, FileAccess.READ)
		var parsed = JSON.parse_string(f.get_as_text())
		f.close()
		if parsed is Array:
			existing = parsed
	existing.append_array(_events)
	var f = FileAccess.open(TELEMETRY_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(existing))
		f.close()
	_events.clear()

func _on_quest_completed(quest_id: String) -> void:
	track("quest_completed", {"quest_id": quest_id})

func _on_xp_gained(amount: int, source: String) -> void:
	track("xp_gained", {"amount": amount, "source": source})

func _on_dungeon_completed(dungeon_id: String) -> void:
	track("dungeon_completed", {"dungeon_id": dungeon_id})

func get_session_duration() -> int:
	return int(Time.get_unix_time_from_system() - _session_start)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_flush()
