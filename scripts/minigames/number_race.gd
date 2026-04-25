extends Node2D
## NumberRace — Math speed game. 10 questions, 60 second timer.

var score: int = 0
var question_count: int = 0
var time_left: float = 60.0
var correct_answer: int = 0
var active: bool = false
var timer_label: Label
var score_label: Label
var question_label: Label
var feedback_label: Label
var answer_buttons: Array = []

func _ready() -> void:
	_setup_ui()
	_next_question()
	active = true

func _setup_ui() -> void:
	var title = Label.new()
	title.text = "Number Race!"
	title.position = Vector2(150, 10)
	title.add_theme_font_size_override("font_size", 24)
	add_child(title)
	timer_label = Label.new()
	timer_label.position = Vector2(320, 10)
	add_child(timer_label)
	score_label = Label.new()
	score_label.position = Vector2(10, 10)
	add_child(score_label)
	question_label = Label.new()
	question_label.position = Vector2(120, 100)
	question_label.add_theme_font_size_override("font_size", 48)
	add_child(question_label)
	feedback_label = Label.new()
	feedback_label.position = Vector2(150, 170)
	add_child(feedback_label)
	for i in range(3):
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(100, 60)
		btn.position = Vector2(60 + i * 120, 230)
		btn.add_theme_font_size_override("font_size", 24)
		btn.pressed.connect(_on_answer.bind(i))
		answer_buttons.append(btn)
		add_child(btn)
	var back = Button.new()
	back.text = "Back"
	back.position = Vector2(10, 350)
	back.pressed.connect(_go_back)
	add_child(back)

func _process(delta: float) -> void:
	if not active: return
	time_left -= delta
	timer_label.text = "Time: %d" % int(time_left)
	if time_left <= 0:
		_end_game()

func _next_question() -> void:
	if question_count >= 10:
		_end_game()
		return
	var a = randi() % 9 + 1
	var b = randi() % 9 + 1
	correct_answer = a + b
	question_label.text = "%d + %d = ?" % [a, b]
	question_count += 1
	score_label.text = "Score: %d" % score
	feedback_label.text = ""
	var wrong1 = correct_answer + (randi() % 3 + 1)
	var wrong2 = max(1, correct_answer - (randi() % 3 + 1))
	var answers = [correct_answer, wrong1, wrong2]
	answers.shuffle()
	for i in range(3):
		answer_buttons[i].text = str(answers[i])
		answer_buttons[i].set_meta("value", answers[i])

func _on_answer(btn_index: int) -> void:
	if not active: return
	var val = answer_buttons[btn_index].get_meta("value")
	if val == correct_answer:
		score += 1
		feedback_label.text = "Correct! ⭐"
	else:
		feedback_label.text = "Keep trying!"
	_next_question()

func _end_game() -> void:
	active = false
	question_label.text = "Done! Score: %d/10" % score
	for btn in answer_buttons:
		btn.disabled = true
	EventBus.xp_gained.emit(score * 2, "number_race")

func _go_back() -> void:
	TransitionManager.change_scene("res://scenes/overworld/hearthveil/hearthveil.tscn")
