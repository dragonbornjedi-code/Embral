extends Node2D
## WordCatch — Spell words by picking the missing letter.

const WORDS = ["CAT", "DOG", "SUN", "HAT", "BAG"]
var current_word_index: int = 0
var current_letter_index: int = 0
var word_label: Label
var progress_label: Label
var feedback_label: Label
var instruction_label: Label

func _ready() -> void:
	_setup_ui()
	_show_current_word()

func _setup_ui() -> void:
	var title = Label.new()
	title.text = "Word Catch!"
	title.position = Vector2(150, 10)
	title.add_theme_font_size_override("font_size", 24)
	add_child(title)
	progress_label = Label.new()
	progress_label.position = Vector2(10, 10)
	add_child(progress_label)
	instruction_label = Label.new()
	instruction_label.text = "Pick the missing letter!"
	instruction_label.position = Vector2(100, 60)
	add_child(instruction_label)
	word_label = Label.new()
	word_label.position = Vector2(130, 110)
	word_label.add_theme_font_size_override("font_size", 64)
	add_child(word_label)
	feedback_label = Label.new()
	feedback_label.position = Vector2(150, 200)
	feedback_label.add_theme_font_size_override("font_size", 24)
	add_child(feedback_label)
	var back = Button.new()
	back.text = "Back"
	back.position = Vector2(10, 350)
	back.pressed.connect(_go_back)
	add_child(back)

func _show_current_word() -> void:
	if current_word_index >= WORDS.size():
		_win()
		return
	var word = WORDS[current_word_index]
	var display = ""
	for i in range(word.length()):
		if i == current_letter_index:
			display += "_ "
		else:
			display += word[i] + " "
	word_label.text = display.strip_edges()
	progress_label.text = "Word %d of %d" % [current_word_index + 1, WORDS.size()]
	_show_letter_buttons(word[current_letter_index])

func _show_letter_buttons(correct: String) -> void:
	for child in get_children():
		if child.has_meta("letter_btn"):
			child.queue_free()
	var vowels = ["A", "E", "I", "O", "U"]
	var options: Array = [correct]
	var attempts = 0
	while options.size() < 3 and attempts < 20:
		var l = vowels[randi() % vowels.size()]
		if not options.has(l):
			options.append(l)
		attempts += 1
	if options.size() < 3:
		options.append("X")
	options.shuffle()
	for i in range(options.size()):
		var btn = Button.new()
		btn.text = options[i]
		btn.custom_minimum_size = Vector2(80, 60)
		btn.position = Vector2(80 + i * 100, 280)
		btn.add_theme_font_size_override("font_size", 28)
		btn.set_meta("letter_btn", true)
		btn.pressed.connect(_on_letter_pressed.bind(options[i], correct))
		add_child(btn)

func _on_letter_pressed(chosen: String, correct: String) -> void:
	if chosen == correct:
		feedback_label.text = "Yes! 🌟"
		current_letter_index += 1
		if current_letter_index >= WORDS[current_word_index].length():
			current_word_index += 1
			current_letter_index = 0
		await get_tree().create_timer(0.5).timeout
		_show_current_word()
	else:
		feedback_label.text = "Try again! 💪"

func _win() -> void:
	word_label.text = "Amazing!"
	feedback_label.text = "All words done! 🎉"
	EventBus.xp_gained.emit(15, "word_catch")

func _go_back() -> void:
	TransitionManager.change_scene("res://scenes/overworld/hearthveil/hearthveil.tscn")
