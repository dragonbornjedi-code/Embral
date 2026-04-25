extends Node
class_name ErrorLogger

const LOG_PATH = "user://logs/error_log.txt"

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute("user://logs")
	get_tree().node_added.connect(_on_node_added)

func log_error(message: String, context: String = "") -> void:
	var timestamp = Time.get_datetime_string_from_system()
	var entry = "[%s] ERROR [%s]: %s\n" % [timestamp, context, message]
	push_error(entry)
	_write_to_file(entry)

func log_warning(message: String, context: String = "") -> void:
	var timestamp = Time.get_datetime_string_from_system()
	var entry = "[%s] WARN [%s]: %s\n" % [timestamp, context, message]
	push_warning(entry)
	_write_to_file(entry)

func log_info(message: String, context: String = "") -> void:
	var timestamp = Time.get_datetime_string_from_system()
	var entry = "[%s] INFO [%s]: %s\n" % [timestamp, context, message]
	print(entry)
	_write_to_file(entry)

func _write_to_file(entry: String) -> void:
	var f = FileAccess.open(LOG_PATH, FileAccess.READ_WRITE)
	if f == null:
		f = FileAccess.open(LOG_PATH, FileAccess.WRITE)
	if f:
		f.seek_end()
		f.store_string(entry)
		f.close()

func get_recent_logs(count: int = 20) -> Array[String]:
	var lines: Array[String] = []
	if not FileAccess.file_exists(LOG_PATH):
		return lines
	var f = FileAccess.open(LOG_PATH, FileAccess.READ)
	var content = f.get_as_text()
	f.close()
	var all_lines = content.split("\n")
	var start = max(0, all_lines.size() - count)
	for i in range(start, all_lines.size()):
		if all_lines[i] != "":
			lines.append(all_lines[i])
	return lines

func _on_node_added(_node: Node) -> void:
	pass
