extends Node
## QuestManager — Loads quest JSON, tracks completion, fires rewards.
## All quest content lives in data/quests/{realm}/{quest_id}.json
## No quest content is generated at runtime. Everything is hand-authored.

const QUEST_BASE_PATH := "res://data/quests/"
const NPC_MASTERY_SAVE := "user://save/npc_mastery.json"

var _quests: Dictionary = {}          # quest_id → quest data
var _active_quest: String = ""
var _active_step: int = 0
var _npc_mastery: Dictionary = {}     # npc_id → {level, scores[]}


func _ready() -> void:
	_load_npc_mastery()


# ───────────────────────────────────────────
# QUEST LOADING
# ───────────────────────────────────────────

## Load all quests for a realm into memory
func load_realm_quests(realm_id: String) -> void:
	var path := QUEST_BASE_PATH + realm_id + "/"
	var dir := DirAccess.open(path)
	if dir == null:
		push_warning("[QuestManager] No quest directory for realm: %s" % realm_id)
		return
	dir.list_dir_begin()
	var fname := dir.get_next()
	while fname != "":
		if fname.ends_with(".json"):
			_load_quest_file(path + fname)
		fname = dir.get_next()
	dir.list_dir_end()


func _load_quest_file(full_path: String) -> void:
	var file := FileAccess.open(full_path, FileAccess.READ)
	if file == null:
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if parsed == null or not parsed is Dictionary:
		push_error("[QuestManager] Invalid quest JSON: %s" % full_path)
		return
	var quest_id: String = parsed.get("quest_id", "")
	if quest_id == "":
		push_error("[QuestManager] Quest missing quest_id: %s" % full_path)
		return
	_quests[quest_id] = parsed


## Get quest data by ID
func get_quest(quest_id: String) -> Dictionary:
	return _quests.get(quest_id, {})


## Get all available quests for an NPC (respects age range and prerequisites)
func get_available_quests_for_npc(npc_id: String, player_level: int) -> Array:
	var available := []
	for quest_id in _quests:
		var q: Dictionary = _quests[quest_id]
		if q.get("npc_giver", "") != npc_id:
			continue
		# Check prerequisites
		var prereqs: Array = q.get("prerequisite_quests", [])
		var prereqs_met := true
		for prereq in prereqs:
			if not is_quest_completed(prereq):
				prereqs_met = false
				break
		if prereqs_met:
			available.append(quest_id)
	return available


# ───────────────────────────────────────────
# QUEST EXECUTION
# ───────────────────────────────────────────

func start_quest(quest_id: String) -> void:
	if not _quests.has(quest_id):
		push_error("[QuestManager] Quest not found: %s" % quest_id)
		return
	_active_quest = quest_id
	_active_step = 0
	EventBus.quest_started.emit(quest_id)


func complete_step(score: float = 1.0) -> void:
	if _active_quest == "":
		return
	var quest: Dictionary = _quests.get(_active_quest, {})
	var steps: Array = quest.get("steps", [])
	EventBus.quest_step_completed.emit(_active_quest, _active_step)
	_active_step += 1
	if _active_step >= steps.size():
		_complete_quest(score)


func _complete_quest(final_score: float) -> void:
	var quest: Dictionary = _quests.get(_active_quest, {})
	var npc_id: String = quest.get("npc_giver", "")
	# Record completion
	SaveManager.mark_quest_complete(_active_quest, final_score)
	# Update NPC mastery
	if npc_id != "":
		_record_npc_score(npc_id, final_score)
	# Grant rewards
	var rewards: Dictionary = quest.get("completion_reward", {})
	if rewards.has("xp"):
		EventBus.xp_gained.emit(rewards["xp"], _active_quest)
	if rewards.has("gold"):
		EventBus.gold_gained.emit(rewards["gold"], _active_quest)
	EventBus.quest_completed.emit(_active_quest)
	_active_quest = ""
	_active_step = 0


func is_quest_completed(quest_id: String) -> bool:
	return SaveManager.is_quest_complete(quest_id) if \
		get_node_or_null("/root/SaveManager") != null else false


# ───────────────────────────────────────────
# NPC MASTERY — Per-NPC score tracking
# ───────────────────────────────────────────

func _record_npc_score(npc_id: String, score: float) -> void:
	if not _npc_mastery.has(npc_id):
		_npc_mastery[npc_id] = {"level": 1, "scores": []}
	_npc_mastery[npc_id]["scores"].append(score)
	_check_mastery_level_up(npc_id)
	_save_npc_mastery()


func _check_mastery_level_up(npc_id: String) -> void:
	var data: Dictionary = _npc_mastery[npc_id]
	var scores: Array = data["scores"]
	if scores.size() < 5:
		return
	# Average of last 5 scores
	var recent := scores.slice(scores.size() - 5)
	var avg: float = 0.0
	for s in recent:
		avg += s
	avg /= recent.size()
	var current_level: int = data["level"]
	# 80% average unlocks next difficulty tier
	if avg >= 0.8 and current_level < 5:
		_npc_mastery[npc_id]["level"] = current_level + 1
		EventBus.npc_mastery_level_up.emit(npc_id, current_level + 1)


func get_npc_mastery_level(npc_id: String) -> int:
	return _npc_mastery.get(npc_id, {}).get("level", 1)


func _load_npc_mastery() -> void:
	if not FileAccess.file_exists(NPC_MASTERY_SAVE):
		return
	var file := FileAccess.open(NPC_MASTERY_SAVE, FileAccess.READ)
	if file == null:
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if parsed is Dictionary:
		_npc_mastery = parsed


func _save_npc_mastery() -> void:
	var dir := DirAccess.open("user://")
	if not dir.dir_exists("save"):
		dir.make_dir("save")
	var file := FileAccess.open(NPC_MASTERY_SAVE, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify(_npc_mastery, "\t"))
	file.close()
