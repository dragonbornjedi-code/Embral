extends Node
## SaveManager — Handles all game state persistence for multiple profiles.
## Each profile has its own user://save/{profile_id}/ directory.
##
## Law 10: All saves go to user:// on the player's machine.
## Law 11: Quests, NPC mastery, and player stats are saved locally only.

const PROFILES_DIR := "user://save/"
const PROFILES_LIST := "user://save/profiles.json"
const PROFILE_FILE := "profile.json"
const SCHEMA_VERSION := 1

var PlayerProfileScript = load("res://scripts/models/player_profile.gd")

signal profiles_updated
signal active_profile_changed(profile_id)

var active_profile: Resource = null
var _profiles: Array = [] # List of {id: String, name: String, last_played: int}


func _ready() -> void:
	_ensure_save_dir()
	_load_profile_list()


func _ensure_save_dir() -> void:
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("save"):
		dir.make_dir("save")


# ───────────────────────────────────────────
# PROFILE MANAGEMENT
# ───────────────────────────────────────────

func get_profile_list() -> Array:
	return _profiles


func create_profile(player_name: String) -> String:
	var id = _generate_profile_id(player_name)
	var profile_dir = PROFILES_DIR + id + "/"
	
	var dir = DirAccess.open("user://")
	dir.make_dir_recursive(profile_dir)
	
	var profile = PlayerProfileScript.new()
	profile.profile_id = id
	profile.player_name = player_name
	
	_save_profile_file(profile)
	
	_profiles.append({
		"id": id,
		"name": player_name,
		"last_played": profile.last_played_at
	})
	_save_profile_list()
	
	profiles_updated.emit()
	return id


func select_profile(profile_id: String) -> bool:
	var path = PROFILES_DIR + profile_id + "/" + PROFILE_FILE
	if not FileAccess.file_exists(path):
		push_error("[SaveManager] Profile file not found: %s" % path)
		return false
	
	var file = FileAccess.open(path, FileAccess.READ)
	var parsed = JSON.parse_string(file.get_as_text())
	file.close()
	
	if not parsed is Dictionary:
		push_error("[SaveManager] Invalid profile data for %s" % profile_id)
		return false
		
	active_profile = PlayerProfileScript.from_dict(parsed)
	active_profile.last_played_at = int(Time.get_unix_time_from_system())
	_save_profile_file(active_profile)
	
	# Update last_played in profile list
	for p in _profiles:
		if p["id"] == profile_id:
			p["last_played"] = active_profile.last_played_at
			break
	_save_profile_list()
	
	active_profile_changed.emit(profile_id)
	print("[SaveManager] Profile selected: %s (%s)" % [active_profile.player_name, profile_id])
	return true


func delete_profile(profile_id: String) -> void:
	var profile_dir = PROFILES_DIR + profile_id + "/"
	_delete_recursive(profile_dir)
	
	_profiles = _profiles.filter(func(p): return p["id"] != profile_id)
	_save_profile_list()
	
	if active_profile and active_profile.profile_id == profile_id:
		active_profile = null
		active_profile_changed.emit("")
		
	profiles_updated.emit()


# ───────────────────────────────────────────
# DATA IO
# ───────────────────────────────────────────

func save_current_profile() -> void:
	if active_profile:
		_save_profile_file(active_profile)


func mark_quest_complete(quest_id: String, score: float) -> void:
	if active_profile:
		active_profile.quest_completion[quest_id] = {
			"completed": true,
			"score": score,
			"timestamp": int(Time.get_unix_time_from_system())
		}
		save_current_profile()


func is_quest_complete(quest_id: String) -> bool:
	if not active_profile: return false
	return active_profile.quest_completion.get(quest_id, {}).get("completed", false)


# ───────────────────────────────────────────
# INTERNAL
# ───────────────────────────────────────────

func _generate_profile_id(player_name: String) -> String:
	var base = player_name.to_lower().replace(" ", "_")
	var id = base
	var count = 1
	while _profile_exists(id):
		id = base + "_" + str(count)
		count += 1
	return id


func _profile_exists(id: String) -> bool:
	for p in _profiles:
		if p["id"] == id:
			return true
	return false


func _load_profile_list() -> void:
	if not FileAccess.file_exists(PROFILES_LIST):
		_profiles = []
		return
	var file = FileAccess.open(PROFILES_LIST, FileAccess.READ)
	var parsed = JSON.parse_string(file.get_as_text())
	file.close()
	if parsed is Dictionary:
		_profiles = parsed.get("profiles", [])
	else:
		_profiles = []


func _save_profile_list() -> void:
	var file = FileAccess.open(PROFILES_LIST, FileAccess.WRITE)
	var data = {"profiles": _profiles}
	file.store_string(JSON.stringify(data, "\t"))
	file.close()


func _save_profile_file(profile: Resource) -> void:
	var path = PROFILES_DIR + profile.profile_id + "/" + PROFILE_FILE
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(profile.to_dict(), "\t"))
	file.close()


func _delete_recursive(path: String) -> void:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				_delete_recursive(path + file_name + "/")
			else:
				dir.remove(file_name)
			file_name = dir.get_next()
		DirAccess.remove_absolute(path)
