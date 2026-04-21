extends Node
## SqliteDB — Circuit-breaker stub for Godot-SQLite.
## When a compatible SQLite GDExtension is available, this autoload exposes a
## minimal query API. Otherwise all calls return null/false and log warnings.
##
## Callers must handle null returns gracefully:
##   var rows = SqliteDB.query("SELECT ...")
##   if rows == null: return  # SQLite not available, use JSON fallback

const _EXPECTED_ADDON_PATH := "res://addons/sqlite3/gdext.gdextension"
const _ALT_ADDON_PATH := "" # No alternative path needed
const _DB_PATH := "user://save/embral.sqlite3"

var _available: bool = false
var _binding_on_disk: bool = false
var _warned: bool = false
var _wrapper: Object = null
var _db: Object = null


func _ready() -> void:
	var has_expected := FileAccess.file_exists(_EXPECTED_ADDON_PATH)
	var has_alt := FileAccess.file_exists(_ALT_ADDON_PATH)
	_binding_on_disk = has_expected or has_alt
	if not _binding_on_disk:
		push_warning("[SqliteDB] No SQLite binding configured for the active project. All queries return null. JSON fallback active.")
		return

	if not ClassDB.class_exists("Sqlite3Wrapper") or not ClassDB.class_exists("Sqlite3Handle") or not ClassDB.class_exists("Sqlite3StmtHandle"):
		push_error("[SqliteDB] SQLite binding is missing or misconfigured. Expected Sqlite3Wrapper, Sqlite3Handle, and Sqlite3StmtHandle classes.")
		push_warning("[SqliteDB] SQLite binding is on disk, but runtime classes are unavailable. Queries still return null.")
		return

	_wrapper = ClassDB.instantiate("Sqlite3Wrapper")
	if _open_database():
		_available = true
		print("[SqliteDB] SQLite binding active at %s." % ProjectSettings.globalize_path(_DB_PATH))
	else:
    push_error("[SqliteDB] SQLite binding is present on disk, but database open failed. Queries will fail.")


func is_available() -> bool:
	return _available


func has_binding_on_disk() -> bool:
	return _binding_on_disk


func get_database_path() -> String:
	return _DB_PATH


func _exit_tree() -> void:
	_close_database()


## Execute a query. Returns an array of row dictionaries.
## For statements that don't return rows, returns [] on success and null on failure.
func query(_sql: String, _bindings: Array = []) -> Variant:
	if not _available:
		_warn_once()
		return null
	return _query_internal(_sql, _bindings)


func _query_internal(_sql: String, _bindings: Array = []) -> Variant:
	if _wrapper == null or _db == null:
		return null

	var stmt: Object = ClassDB.instantiate("Sqlite3StmtHandle")
	var prep_code: int = _wrapper.prepare(_db, _sql, -1, stmt)
	if prep_code != _wrapper.ok():
		push_error("[SqliteDB] Prepare failed: %s | SQL: %s" % [_wrapper.errmsg(_db), _sql])
		_wrapper.finalize(stmt)
		return null

	for i in range(_bindings.size()):
		var bind_code := _bind_value(stmt, i + 1, _bindings[i])
		if bind_code != _wrapper.ok():
			push_error("[SqliteDB] Bind failed at index %d: %s" % [i + 1, _wrapper.errmsg(_db)])
			_wrapper.finalize(stmt)
			return null

	var rows: Array = []
	while true:
		var step_code: int = _wrapper.step(stmt)
		if step_code == _wrapper.row():
			rows.append(_read_row(stmt))
			continue
		if step_code == _wrapper.done():
			break
		push_error("[SqliteDB] Step failed: %s | SQL: %s" % [_wrapper.errmsg(_db), _sql])
		_wrapper.finalize(stmt)
		return null

	_wrapper.finalize(stmt)
	return rows


func execute(_sql: String, _bindings: Array = []) -> bool:
	return query(_sql, _bindings) != null


func _open_database() -> bool:
	_ensure_save_dir()
	_db = ClassDB.instantiate("Sqlite3Handle")
	var open_code: int = _wrapper.open(ProjectSettings.globalize_path(_DB_PATH), _db)
	if open_code != _wrapper.ok():
		_db = null
		return false
	return _initialize_schema()


func _initialize_schema() -> bool:
	return _query_internal("CREATE TABLE IF NOT EXISTS system_meta (key TEXT PRIMARY KEY, value TEXT NOT NULL)") != null


func _close_database() -> void:
	if _available and _wrapper != null and _db != null and _db.is_valid():
		_wrapper.close(_db)
	_available = false


func _ensure_save_dir() -> void:
	var dir := DirAccess.open("user://")
	if dir != null and not dir.dir_exists("save"):
		dir.make_dir("save")


func _bind_value(stmt: Object, index: int, value: Variant) -> int:
	match typeof(value):
		TYPE_NIL:
			return _wrapper.bind_null(stmt, index)
		TYPE_BOOL:
			return _wrapper.bind_int64(stmt, index, 1 if value else 0)
		TYPE_INT:
			return _wrapper.bind_int64(stmt, index, value)
		TYPE_FLOAT:
			return _wrapper.bind_double(stmt, index, value)
		TYPE_STRING, TYPE_STRING_NAME:
			var text: String = str(value)
			return _wrapper.bind_text(stmt, index, text, text.length(), _wrapper.transient_destructor_type())
		_:
			var coerced: String = JSON.stringify(value)
			return _wrapper.bind_text(stmt, index, coerced, coerced.length(), _wrapper.transient_destructor_type())


func _read_row(stmt: Object) -> Dictionary:
	var row: Dictionary = {}
	var count: int = _wrapper.column_count(stmt)
	for i in range(count):
		var column_name: String = str(_wrapper.column_name(stmt, i))
		row[column_name] = _read_column_value(stmt, i)
	return row


func _read_column_value(stmt: Object, index: int) -> Variant:
	var value_type: int = _wrapper.column_type(stmt, index)
	if value_type == _wrapper.sqlite_null():
		return null
	if value_type == _wrapper.sqlite_integer():
		return _wrapper.column_int64(stmt, index)
	if value_type == _wrapper.sqlite_float():
		return _wrapper.column_double(stmt, index)
	if value_type == _wrapper.sqlite_blob():
		return _wrapper.column_blob(stmt, index)
	return _wrapper.column_text(stmt, index)


func _warn_once() -> void:
	if _warned:
		return
	_warned = true
    push_error("[SqliteDB] Query called while SQLite runtime integration is unavailable. No fallback available.")
