extends Node2D

var sounds = {"B": "buh", "A": "aah", "S": "sss", "T": "tuh", "M": "mmm", "R": "rrr", "L": "lll", "N": "nnn", "F": "fff", "K": "kuh"}
var current_letter: String = ""
var feedback: Label

func _ready() -> void:
    _setup_ui()
    _next_round()

func _setup_ui() -> void:
    feedback = Label.new()
    feedback.position = Vector2(20, 20)
    add_child(feedback)
    
    var back = Button.new()
    back.text = "Back"
    back.pressed.connect(_go_back)
    add_child(back)

func _next_round() -> void:
    var keys = sounds.keys()
    current_letter = keys[randi() % keys.size()]
    # Display letter, buttons for sounds
    pass

func _on_sound_button(sound: String) -> void:
    if sound == sounds[current_letter]:
        feedback.text = "Correct! 🌟"
    else:
        feedback.text = "Try again!"

func _go_back() -> void:
    TransitionManager.change_scene("res://scenes/overworld/hearthveil/hearthveil.tscn")
