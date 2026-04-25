extends Node2D

const WORDS = ["CAT", "DOG", "SUN", "HAT", "BAG"]
var current_word_index: int = 0
var current_letter_index: int = 0
var feedback_label: Label
var word_label: Label
var progress_label: Label

func _ready() -> void:
    _setup_ui()
    _show_word()

func _setup_ui() -> void:
    word_label = Label.new()
    word_label.position = Vector2(150, 80)
    word_label.add_theme_font_size_override("font_size", 48)
    add_child(word_label)
    progress_label = Label.new()
    progress_label.position = Vector2(50, 20)
    add_child(progress_label)
    feedback_label = Label.new()
    feedback_label.position = Vector2(150, 200)
    add_child(feedback_label)
    
    var back = Button.new()
    back.text = "Back"
    back.position = Vector2(10, 10)
    back.pressed.connect(_go_back)
    add_child(back)

func _show_word() -> void:
    if current_word_index >= WORDS.size():
        _win()
        return
    var word = WORDS[current_word_index]
    var display = ""
    for i in range(word.length()):
        display += "_" if i == current_letter_index else word[i]
    word_label.text = display
    progress_label.text = "Word %d of %d" % [current_word_index + 1, WORDS.size()]
    _show_letter_buttons(word[current_letter_index])

func _show_letter_buttons(correct: String) -> void:
    for child in get_children():
        if child.get_meta("letter_btn", false):
            child.queue_free()
    
    var options = [correct]
    var alphabet = "AEIOU"
    while options.size() < 3:
        var l = alphabet[randi() % alphabet.length()]
        if not options.has(l):
            options.append(l)
    options.shuffle()
    
    for i in range(3):
        var btn = Button.new()
        btn.text = options[i]
        btn.custom_minimum_size = Vector2(80, 60)
        btn.position = Vector2(80 + i * 100, 300)
        btn.set_meta("letter_btn", true)
        btn.pressed.connect(_on_letter.bind(options[i], correct))
        add_child(btn)

func _on_letter(chosen: String, correct: String) -> void:
    if chosen == correct:
        feedback_label.text = "Yes! 🌟"
        current_letter_index += 1
        if current_letter_index >= WORDS[current_word_index].length():
            current_word_index += 1
            current_letter_index = 0
        _show_word()
    else:
        feedback_label.text = "Try again!"

func _win() -> void:
    word_label.text = "Amazing! All words done!"
    EventBus.xp_gained.emit(15, "word_catch")

func _go_back() -> void:
    TransitionManager.change_scene("res://scenes/overworld/hearthveil/hearthveil.tscn")
