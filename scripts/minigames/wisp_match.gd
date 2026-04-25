extends Node2D
## WispMatch — Memory card matching game.

const ELEMENTS = ["fire","water","wind","earth","fire","water","wind","earth"]
var cards: Array = []
var flipped: Array = []
var matched_count: int = 0
var can_flip: bool = true

func _ready() -> void:
	_setup_board()

func _setup_board() -> void:
	var shuffled = ELEMENTS.duplicate()
	shuffled.shuffle()
	for i in range(8):
		var btn = Button.new()
		btn.text = "?"
		btn.custom_minimum_size = Vector2(80, 80)
		btn.pressed.connect(_on_card_pressed.bind(i, shuffled[i]))
		cards.append({"button": btn, "element": shuffled[i], "matched": false})
		add_child(btn)
		btn.position = Vector2((i % 4) * 100 + 50, (i / 4) * 100 + 100)
	
	var label = Label.new()
	label.text = "Match the Wisps!"
	label.position = Vector2(50, 20)
	add_child(label)
	
	var back = Button.new()
	back.text = "Back"
	back.position = Vector2(10, 10)
	back.pressed.connect(_go_back)
	add_child(back)

func _on_card_pressed(index: int, element: String) -> void:
	if not can_flip: return
	if cards[index]["matched"]: return
	if flipped.size() == 2: return
	
	cards[index]["button"].text = element
	flipped.append(index)
	
	if flipped.size() == 2:
		can_flip = false
		await get_tree().create_timer(1.0).timeout
		_check_match()

func _check_match() -> void:
	var a = flipped[0]
	var b = flipped[1]
	if cards[a]["element"] == cards[b]["element"]:
		cards[a]["matched"] = true
		cards[b]["matched"] = true
		matched_count += 1
		if matched_count == 4:
			_win()
	else:
		cards[a]["button"].text = "?"
		cards[b]["button"].text = "?"
	flipped.clear()
	can_flip = true

func _win() -> void:
	EventBus.xp_gained.emit(20, "wisp_match")
	var label = Label.new()
	label.text = "Great job! All matched!"
	label.position = Vector2(100, 350)
	add_child(label)

func _go_back() -> void:
	TransitionManager.change_scene("res://scenes/overworld/hearthveil/hearthveil.tscn")
