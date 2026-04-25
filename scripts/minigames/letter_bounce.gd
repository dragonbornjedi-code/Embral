extends Node2D
## LetterBounce — Match letters to their sounds. 10 rounds.

const LETTERS = ["B", "C", "D", "F", "G", "H", "M", "P", "S", "T"]
const SOUNDS = {
	"B": "buh", "C": "kuh", "D": "duh", "F": "fff",
	"G": "guh", "H": "huh", "M": "mmm", "P": "puh",
	"S": "sss", "T": "tuh"
}
const ALL_SOUNDS = ["buh", "kuh", "duh", "fff", "guh", "huh", "mmm", "puh", "sss", "tuh"]

var current_index: int = 0
var score: int = 0
var letter_label: Label
var score_label: Label
var progress_label: Label
var feedback_label: Label

func _ready() -> void:
	_setup_ui()
	_show_letter()

func _setup_ui() -> void:
	var title = Label.new()
	title.text = "Letter Bounce!"
	title.position = Vector2(130, 10)
	title.add_theme_font_size_override("font_size", 24)
	add_child(title)
	progress_label = Label.new()
	progress_label.position = Vector2(10, 10)
	add_child(progress_label)
	score_label = Label.new()
	score_label.position = Vector2(320, 10)
	add_child(score_label)
	var instruction = Label.new()
	instruction.text = "What sound does this letter make?"
	instruction.position = Vector2(60, 50)
	add_child(instruction)
	letter_label = Label.new()
	letter_label.position = Vector2(180, 100)
	letter_label.add_theme_font_size_override("font_size", 96)
	add_child(letter_label)
	feedback_label = Label.new()
	feedback_label.position = Vector2(150, 230)
	feedback_label.add_theme_font_size_override("font_size", 24)
	add_child(feedback_label)
	var back = Button.new()
	back.text = "Back"
	back.position = Vector2(10, 360)
	back.pressed.connect(_go_back)
	add_child(back)

func _show_letter() -> void:
	if current_index >= LETTERS.size():
		_win()
		return
	var letter = LETTERS[current_index]
	letter_label.text = letter
	progress_label.text = "%d/%d" % [current_index + 1, LETTERS.size()]
	score_label.text = "Score: %d" % score
	feedback_label.text = ""
	_show_sound_buttons(letter)

func _show_sound_buttons(letter: String) -> void:
	for child in get_children():
		if child.has_meta("sound_btn"):
			child.queue_free()
	var correct = SOUNDS[letter]
	var options: Array = [correct]
	var attempts = 0
	while options.size() < 3 and attempts < 20:
		var s = ALL_SOUNDS[randi() % ALL_SOUNDS.size()]
		if not options.has(s):
			options.append(s)
		attempts += 1
	options.shuffle()
	for i in range(options.size()):
		var btn = Button.new()
		btn.text = '"%s"' % options[i]
		btn.custom_minimum_size = Vector2(110, 55)
		btn.position = Vector2(50 + i * 120, 290)
		btn.add_theme_font_size_override("font_size", 20)
		btn.set_meta("sound_btn", true)
		btn.pressed.connect(_on_sound_pressed.bind(options[i], correct))
		add_child(btn)

func _on_sound_pressed(chosen: String, correct: String) -> void:
	if chosen == correct:
		score += 1
		feedback_label.text = "Yes! 🌟"
	else:
		feedback_label.text = "The sound is \"%s\"! 💪" % correct
	current_index += 1
	await get_tree().create_timer(0.8).timeout
	_show_letter()

func _win() -> void:
	letter_label.text = "🎉"
	feedback_label.text = "Great job! Score: %d/10" % score
	EventBus.xp_gained.emit(15, "letter_bounce")

func _go_back() -> void:
	TransitionManager.change_scene("res://scenes/overworld/hearthveil/hearthveil.tscn")
