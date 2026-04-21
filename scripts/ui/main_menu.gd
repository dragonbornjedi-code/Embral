extends Control

@onready var start_button = $CenterContainer/MainVBox/StartButton
@onready var options_button = $CenterContainer/MainVBox/OptionsButton
@onready var quit_button = $CenterContainer/MainVBox/QuitButton

func _ready():
    start_button.pressed.connect(_on_start_pressed)
    options_button.pressed.connect(_on_options_pressed)
    quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
    print("Start Game pressed")
    # TODO: Transition to ProfileSelect

func _on_options_pressed():
    print("Options pressed")

func _on_quit_pressed():
    get_tree().quit()
