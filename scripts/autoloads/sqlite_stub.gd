extends Node
## SqliteDB — Circuit-breaker stub for Godot-SQLite.
## When the real GDExtension is not installed, all calls return null/false
## and log a single warning. No crash. No silent failure.
##
## To install the real addon:
##   1. Download godot-sqlite from https://github.com/2shady4u/godot-sqlite
##   2. Place in addons/godot-sqlite/
##   3. Replace this file's implementation with real SQLiteWrapper calls.
##   4. Update compatibility.md with the installed version.
##
## Callers must handle null returns gracefully:
##   var rows = SqliteDB.query("SELECT ...")
##   if rows == null: return  # SQLite not available, use JSON fallback

const _ADDON_PATH := "res://addons/godot-sqlite/bin/godot-sqlite.gdextension"

var _available: bool = false
var _warned: bool = false


func _ready() -> void:
	_available = FileAccess.file_exists(_ADDON_PATH)
	if _available:
		print("[SqliteDB] Godot-SQLite extension found. Real implementation needed.")
	else:
		push_warning("[SqliteDB] Godot-SQLite not installed. All queries return null. JSON fallback active.")


func is_available() -> bool:
	return _available


## Execute a query. Returns null when SQLite is not installed.
func query(_sql: String, _bindings: Array = []) -> Variant:
	if not _available:
		_warn_once()
		return null
	push_error("[SqliteDB] Real SQLite implementation not wired up yet.")
	return null


func _warn_once() -> void:
	if _warned:
		return
	_warned = true
	push_warning("[SqliteDB] Query called but SQLite is not installed. Using JSON fallback.")
