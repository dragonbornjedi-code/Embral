extends CanvasLayer
## HUD variant used by scenes/ui/PlayerHUD.tscn (TopBar + ActiveQuest layout).

@onready var _level_label: Label = $TopBar/LevelPanel/LevelLabel
@onready var _xp_bar: ProgressBar = $TopBar/XPBar
@onready var _xp_label: Label = $TopBar/XPBar/XPLabel
@onready var _gold_label: Label = $TopBar/GoldPanel/GoldLabel
@onready var _quest_label: Label = $ActiveQuest/QuestLabel
@onready var _hint_label: Label = $FirstSteps/HintLabel


func _ready() -> void:
	_refresh_all()
	if EventBus.has_signal("gold_gained"):
		EventBus.gold_gained.connect(func(_a: int, _s: String) -> void: _refresh_gold())
	if EventBus.has_signal("xp_gained"):
		EventBus.xp_gained.connect(func(_a: int, _s: String) -> void: _refresh_xp())
	if EventBus.has_signal("quest_started"):
		EventBus.quest_started.connect(_on_quest_started)
	if EventBus.has_signal("quest_completed"):
		EventBus.quest_completed.connect(func(_id: String) -> void: _clear_quest())


func _refresh_all() -> void:
	if SaveManager.active_profile:
		_level_label.text = "Lv.%d" % SaveManager.active_profile.level
	else:
		_level_label.text = "Lv.1"
	_refresh_xp()
	_refresh_gold()
	_clear_quest()


func _refresh_gold() -> void:
	var g := 0
	if SaveManager.active_profile:
		g = SaveManager.active_profile.gold
	_gold_label.text = str(g)


func _refresh_xp() -> void:
	if SaveManager.active_profile:
		_xp_bar.value = float(SaveManager.active_profile.xp)
		_xp_label.text = "%d / 100" % SaveManager.active_profile.xp
	else:
		_xp_bar.value = 0.0
		_xp_label.text = "0 / 100"


func _clear_quest() -> void:
	_quest_label.text = "First Steps"


func _on_quest_started(quest_id: String) -> void:
	var q: Variant = QuestManager.get_quest(quest_id)
	if q is Dictionary:
		_quest_label.text = str(q.get("title", "Quest"))
	else:
		_quest_label.text = "Quest"


func set_hub_objective(text: String) -> void:
	_quest_label.text = "First Steps"
	_hint_label.text = text


func set_tutorial_objective(title: String, objective: String) -> void:
	_quest_label.text = title
	_hint_label.text = objective


func show_message(text: String) -> void:
	_hint_label.text = text
