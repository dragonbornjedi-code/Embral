extends Control

@onready var main_container = $MainContainer
var profile_container: PanelContainer
var profile_list: VBoxContainer

@onready var start_button = $MainContainer/MainVBox/StartButton
@onready var options_button = $MainContainer/MainVBox/OptionsButton
@onready var dashboard_button = $MainContainer/MainVBox/ParentDashboardButton
@onready var quit_button = $MainContainer/MainVBox/QuitButton

@onready var settings_menu = %SettingsMenu
@onready var parent_dashboard = %ParentDashboard

func _ready():
    start_button.pressed.connect(_on_start_pressed)
    options_button.pressed.connect(_on_options_pressed)
    dashboard_button.pressed.connect(_on_dashboard_pressed)
    quit_button.pressed.connect(_on_quit_pressed)
    
    # Create ProfileContainer if it doesn't exist (white-box implementation)
    if not has_node("ProfileContainer"):
        _create_whitebox_profile_ui()

    call_deferred("_set_initial_focus")

func _on_start_pressed():
    main_container.hide()
    profile_container.show()
    _refresh_profile_list()

func _on_options_pressed():
    settings_menu.open()

func _on_dashboard_pressed():
    parent_dashboard.open()

func _on_quit_pressed():
    get_tree().quit()

func _refresh_profile_list():
    # Clear existing
    for child in profile_list.get_children():
        child.queue_free()
    
    var profiles = get_node("/root/SaveManager").get_profile_list()
    
    if profiles.is_empty():
        var label = Label.new()
        label.text = "No profiles found. Create your first one!"
        profile_list.add_child(label)
    else:
        for p in profiles:
            var btn = Button.new()
            btn.text = "%s (Last played: %s)" % [p.name, Time.get_datetime_string_from_unix_time(p.last_played)]
            btn.pressed.connect(func(): _on_profile_selected(p.id))
            profile_list.add_child(btn)
    
    var new_btn = Button.new()
    new_btn.text = "[ + Create New Profile ]"
    new_btn.pressed.connect(_on_create_new_pressed)
    profile_list.add_child(new_btn)
    
    var back_btn = Button.new()
    back_btn.text = "< Back"
    back_btn.pressed.connect(func():
        profile_container.hide()
        main_container.show()
    )
    profile_list.add_child(back_btn)

func _on_profile_selected(profile_id: String):
    if get_node("/root/SaveManager").select_profile(profile_id):
        # Transition to Hearthveil (Roadmap 2.07)
        get_node("/root/TransitionManager").change_scene("res://scenes/overworld/Main.tscn")

func _on_create_new_pressed():
    # Simple prompt for white-box phase
    # In a real build, this would be a proper LineEdit popup
    var player_name = "Player" # Default for now
    var id = get_node("/root/SaveManager").create_profile(player_name)
    _on_profile_selected(id)

func _create_whitebox_profile_ui():
    profile_container = PanelContainer.new()
    profile_container.name = "ProfileContainer"
    profile_container.hide()
    add_child(profile_container)
    
    # Center it
    
    profile_list = VBoxContainer.new()

func _set_initial_focus() -> void:
    var buttons = find_children("*", "Button", true, false)
    if buttons.size() > 0:
        buttons[0].grab_focus()
    # Center it
    profile_container.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)
    
    profile_list = VBoxContainer.new()
    profile_list.name = "ProfileList"
    profile_container.add_child(profile_list)
