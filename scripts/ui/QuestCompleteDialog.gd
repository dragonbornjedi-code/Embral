extends CanvasLayer
## Parent-confirms quest completion (Hearthveil UI).

@onready var _quest_name: Label = $CenterContainer/Panel/VBox/QuestName
@onready var _quest_desc: Label = $CenterContainer/Panel/VBox/QuestDesc
@onready var _confirm: Button = $CenterContainer/Panel/VBox/Buttons/ConfirmButton
@onready var _cancel: Button = $CenterContainer/Panel/VBox/Buttons/CancelButton

var _quest_id: String = ""


func _ready() -> void:
	hide()
	_confirm.pressed.connect(_on_confirm)
	_cancel.pressed.connect(_on_cancel)


func show_for_quest(quest_id: String) -> void:
	_quest_id = quest_id
	var q: Variant = QuestManager.get_quest(quest_id)
	if q is Dictionary:
		_quest_name.text = str(q.get("title", quest_id))
		_quest_desc.text = str(q.get("description", ""))
	else:
		_quest_name.text = quest_id
		_quest_desc.text = ""
	show()


func _on_confirm() -> void:
	if _quest_id != "":
		EventBus.quest_completed.emit(_quest_id)
	hide()


func _on_cancel() -> void:
	hide()
