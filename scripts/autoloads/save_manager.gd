extends Node
## SaveManager — Handles game state persistence
## Serializes quest progress, NPC mastery, inventory, and player stats.

const SAVE_PATH := "user://save_game.json"

var _save_data: Dictionary = {}


func _ready() -> void:
	_load()


func _load() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		_save_data = _default_save_data()
		_save()
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("[SaveManager] Could not open save file.")
		return
	var text := file.get_as_text()
	file.close()
	var parsed: Variant = JSON.parse_string(text)
	if parsed == null or not parsed is Dictionary:
		push_error("[SaveManager] Save file is invalid JSON.")
		return
	_save_data = parsed


func _save() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("[SaveManager] Could not write save file.")
		return
	file.store_string(JSON.stringify(_save_data, "\t"))
	file.close()


func _default_save_data() -> Dictionary:
	return {
		"quests": {},
		"npcs": {},
		"inventory": [],
		"player": {
			"level": 1,
			"xp": 0,
			"gold": 0
		}
	}


# ═══════════════════════════════════════════
# QUEST PERSISTENCE
# ═══════════════════════════════════════════

func mark_quest_complete(quest_id: String, score: float) -> void:
	if not _save_data.has("quests"):
		_save_data["quests"] = {}
	_save_data["quests"][quest_id] = {
		"completed": true,
		"score": score,
		"timestamp": Time.get_unix_time_from_system()
	}
	_save()


func is_quest_complete(quest_id: String) -> bool:
	var quests: Dictionary = _save_data.get("quests", {})
	var quest: Dictionary = quests.get(quest_id, {})
	return quest.get("completed", false)


func get_quest_score(quest_id: String) -> float:
	var quests: Dictionary = _save_data.get("quests", {})
	var quest: Dictionary = quests.get(quest_id, {})
	return float(quest.get("score", 0.0))


func get_npc_mastery(npc_id: String) -> Dictionary:
	var npcs: Dictionary = _save_data.get("npcs", {})
	return npcs.get(npc_id, {"total_score": 0.0, "completed_quests": 0})


# ═══════════════════════════════════════════
# NPC MASTERY PERSISTENCE
# ═══════════════════════════════════════════

func record_npc_score(npc_id: String, score: float) -> void:
	if not _save_data.has("npcs"):
		_save_data["npcs"] = {}
	var npc_data: Dictionary = _save_data["npcs"].get(npc_id, {"total_score": 0.0, "completed_quests": 0})
	npc_data["total_score"] += score
	npc_data["completed_quests"] += 1
	_save_data["npcs"][npc_id] = npc_data
	_save()
