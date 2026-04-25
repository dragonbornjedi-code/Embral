extends Node2D

var emotions = ["Happy", "Sad", "Angry", "Worried", "Excited", "Calm"]
var buckets = {"Feels Good": ["Happy", "Excited", "Calm"], "Feels Hard": ["Sad", "Angry", "Worried"]}
var feedback: Label

func _ready() -> void:
    _setup_ui()

func _setup_ui() -> void:
    feedback = Label.new()
    feedback.position = Vector2(20, 20)
    add_child(feedback)
    
    var h_box = HBoxContainer.new()
    h_box.position = Vector2(50, 100)
    add_child(h_box)
    
    for e in emotions:
        var btn = Button.new()
        btn.text = e
        btn.pressed.connect(_on_emotion.bind(e))
        h_box.add_child(btn)

func _on_emotion(e: String) -> void:
    feedback.text = "Good thinking! %s is a real feeling." % e
    # Logic to move to bucket area would go here
    _check_completion()

func _check_completion() -> void:
    # Logic to check if all emotions sorted
    # For now, auto-complete for demonstration
    pass

func _win() -> void:
    EventBus.xp_gained.emit(15, "emotion_sort")
