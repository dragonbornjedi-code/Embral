extends Node2D

var score: int = 0
var question_count: int = 0
var time_left: float = 60.0
var correct_answer: int = 0
var timer_label: Label
var score_label: Label
var question_label: Label
var answer_buttons: Array = []

func _ready() -> void:
    _setup_ui()
    _next_question()

func _setup_ui() -> void:
    timer_label = Label.new()
    timer_label.position = Vector2(300, 20)
    add_child(timer_label)
    score_label = Label.new()
    score_label.position = Vector2(50, 20)
    add_child(score_label)
    question_label = Label.new()
    question_label.position = Vector2(150, 100)
    question_label.add_theme_font_size_override("font_size", 32)
    add_child(question_label)
    for i in range(3):
        var btn = Button.new()
        btn.custom_minimum_size = Vector2(100, 60)
        btn.position = Vector2(80 + i * 120, 200)
        btn.pressed.connect(_on_answer.bind(i))
        answer_buttons.append(btn)
        add_child(btn)
    var back = Button.new()
    back.text = "Back"
    back.position = Vector2(10, 10)
    back.pressed.connect(_go_back)
    add_child(back)

func _process(delta: float) -> void:
    if question_count >= 10: return
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
    var wrong1 = correct_answer + (randi() % 3 + 1)
    var wrong2 = correct_answer - (randi() % 3 + 1)
    var answers = [correct_answer, wrong1, wrong2]
    answers.shuffle()
    for i in range(3):
        answer_buttons[i].text = str(answers[i])
        answer_buttons[i].set_meta("value", answers[i])
    question_count += 1
    score_label.text = "Score: %d" % score

func _on_answer(btn_index: int) -> void:
    var val = answer_buttons[btn_index].get_meta("value")
    if val == correct_answer:
        score += 1
    _next_question()

func _end_game() -> void:
    EventBus.xp_gained.emit(score * 2, "number_race")
    question_label.text = "Done! Score: %d/10" % score
    for btn in answer_buttons:
        btn.disabled = true

func _go_back() -> void:
    TransitionManager.change_scene("res://scenes/overworld/hearthveil/hearthveil.tscn")
