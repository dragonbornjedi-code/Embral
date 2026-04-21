extends Node
## MainMenu — Handles navigation.

func _ready() -> void:
    $CenterContainer/VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
    $CenterContainer/VBoxContainer/OptionsButton.pressed.connect(_on_options_pressed)
    $CenterContainer/VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
    print("Start Game")

func _on_options_pressed() -> void:
    print("Options")

func _on_quit_pressed() -> void:
    get_tree().quit()
