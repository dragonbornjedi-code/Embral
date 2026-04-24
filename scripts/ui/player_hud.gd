extends CanvasLayer
## PlayerHUD — Manages the always-on HUD display.
## Displays player name, gold, XP, and active quest status.

@onready var name_label = $Control/TopLeft/NameLabel
@onready var gold_label = $Control/TopLeft/GoldLabel
@onready var xp_bar = $Control/TopRight/XPBar
@onready var quest_title = $Control/BottomLeft/QuestTitle
@onready var quest_objective = $Control/BottomLeft/QuestObjective
@onready var settings_button = %SettingsButton
@onready var settings_menu = %SettingsMenu

func _ready() -> void:
	_update_player_name()
	_update_gold(0) # Start at 0 or current profile value
	_update_xp(0)   # Start at 0 or current profile value
	_clear_quest_info()
	
	_connect_signals()
	if is_instance_valid(settings_button):
		settings_button.pressed.connect(func() -> void: settings_menu.open())


func _connect_signals() -> void:
	if EventBus.has_signal("gold_gained"):
		EventBus.gold_gained.connect(_on_gold_gained)
	if EventBus.has_signal("xp_gained"):
		EventBus.xp_gained.connect(_on_xp_gained)
	if EventBus.has_signal("quest_started"):
		EventBus.quest_started.connect(_on_quest_started)
	if EventBus.has_signal("quest_completed"):
		EventBus.quest_completed.connect(_on_quest_completed)
	if EventBus.has_signal("quest_step_completed"):
		EventBus.quest_step_completed.connect(_on_quest_step_completed)
	
	# Listen for profile changes to update name
	if SaveManager.has_signal("active_profile_changed"):
		SaveManager.active_profile_changed.connect(func(_id: String) -> void: _update_player_name())


func _update_player_name() -> void:
	var player_name = "Explorer"
	if SaveManager.active_profile:
		player_name = SaveManager.active_profile.player_name
	name_label.text = player_name


func _update_gold(amount: int) -> void:
	# In a real build, we'd add current amount from profile
	var current = 0
	if SaveManager.active_profile:
		current = SaveManager.active_profile.gold
	gold_label.text = "Gold: %d" % current


func _update_xp(amount: int) -> void:
	if SaveManager.active_profile:
		xp_bar.max_value = 100 # Placeholder for xp_to_next_level
		xp_bar.value = SaveManager.active_profile.xp


func _clear_quest_info() -> void:
	quest_title.text = ""
	quest_objective.text = ""


func _on_gold_gained(amount: int, _source: String) -> void:
	_update_gold(amount)


func _on_xp_gained(amount: int, _source: String) -> void:
	_update_xp(amount)


func _on_quest_started(quest_id: String) -> void:
	var quest = QuestManager.get_quest(quest_id)
	if quest:
		quest_title.text = quest.get("title", "New Quest")
		var steps = quest.get("steps", [])
		if not steps.is_empty():
			quest_objective.text = steps[0].get("instruction", "")


func _on_quest_completed(_quest_id: String) -> void:
	_clear_quest_info()


func _on_quest_step_completed(quest_id: String, step_index: int) -> void:
	var quest = QuestManager.get_quest(quest_id)
	if quest:
		var steps = quest.get("steps", [])
		if step_index + 1 < steps.size():
			quest_objective.text = steps[step_index + 1].get("instruction", "")
