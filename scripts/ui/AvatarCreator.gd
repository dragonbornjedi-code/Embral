extends Control

const COLORS := {
	"blue": Color(0.2, 0.6, 1.0),
	"green": Color(0.2, 0.8, 0.35),
	"gold": Color(1.0, 0.8, 0.15),
	"pink": Color(1.0, 0.45, 0.8),
	"purple": Color(0.65, 0.45, 1.0)
}
const STYLES := ["explorer", "builder", "artist", "guardian"]
const STYLE_MODELS := {
	"explorer": "res://assets/models/kaykit_adventurers/Knight.glb",
	"builder": "res://assets/models/kaykit_adventurers/Barbarian.glb",
	"artist": "res://assets/models/kaykit_adventurers/Mage.glb",
	"guardian": "res://assets/models/kaykit_adventurers/Rogue_Hooded.glb"
}

@onready var _left_panel: VBoxContainer = $Panel/HBox/LeftPanel
@onready var _color_grid: GridContainer = $Panel/HBox/LeftPanel/ColorGrid
@onready var _style_options: HBoxContainer = $Panel/HBox/LeftPanel/HairOptions
@onready var _preview_mesh: MeshInstance3D = $Panel/HBox/RightPanel/PreviewContainer/PreviewViewport/SubViewport/PreviewMesh
@onready var _random_button: Button = $Panel/HBox/RightPanel/RandomButton
@onready var _done_button: Button = $Panel/HBox/RightPanel/DoneButton

var _name_edit: LineEdit
var _selected_color := "blue"
var _selected_style := "explorer"


func _ready() -> void:
	_build_name_field()
	_build_color_buttons()
	_build_style_buttons()
	_random_button.pressed.connect(_randomize)
	_done_button.pressed.connect(_finish)
	_update_preview()
	_name_edit.grab_focus()


func _build_name_field() -> void:
	var label := Label.new()
	label.text = "Name your hero:"
	label.add_theme_font_size_override("font_size", 20)
	_left_panel.add_child(label)
	_left_panel.move_child(label, 2)

	_name_edit = LineEdit.new()
	_name_edit.placeholder_text = "Ezra"
	_name_edit.text = "Ezra"
	_name_edit.max_length = 16
	_left_panel.add_child(_name_edit)
	_left_panel.move_child(_name_edit, 3)


func _build_color_buttons() -> void:
	for color_name in COLORS.keys():
		var button := Button.new()
		button.text = color_name.capitalize()
		button.custom_minimum_size = Vector2(110, 44)
		button.pressed.connect(func() -> void:
			_selected_color = color_name
			_update_preview()
		)
		_color_grid.add_child(button)


func _build_style_buttons() -> void:
	for style in STYLES:
		var button := Button.new()
		button.text = style.capitalize()
		button.custom_minimum_size = Vector2(120, 44)
		button.pressed.connect(func() -> void:
			_selected_style = style
			_update_preview()
		)
		_style_options.add_child(button)


func _randomize() -> void:
	var color_keys := COLORS.keys()
	_selected_color = color_keys[randi() % color_keys.size()]
	_selected_style = STYLES[randi() % STYLES.size()]
	_update_preview()


func _update_preview() -> void:
	for child in _preview_mesh.get_children():
		child.queue_free()

	_preview_mesh.mesh = null
	var model_path: String = STYLE_MODELS.get(_selected_style, STYLE_MODELS["explorer"])
	var packed := load(model_path)
	if packed is PackedScene:
		var avatar: Node3D = packed.instantiate()
		avatar.name = "AvatarPreview"
		avatar.scale = Vector3.ONE * 0.9
		avatar.position = Vector3(0, -0.75, 0)
		_preview_mesh.add_child(avatar)
	else:
		var capsule := CapsuleMesh.new()
		capsule.radius = 0.45
		capsule.height = 1.6
		_preview_mesh.mesh = capsule
		var mat := StandardMaterial3D.new()
		mat.albedo_color = COLORS[_selected_color]
		_preview_mesh.set_surface_override_material(0, mat)


func _finish() -> void:
	var hero_name := _name_edit.text.strip_edges()
	if hero_name == "":
		_name_edit.grab_focus()
		return
	var profile_id: String = SaveManager.create_profile(hero_name, {
		"avatar_color": _selected_color,
		"avatar_style": _selected_style
	})
	if SaveManager.select_profile(profile_id):
		TransitionManager.change_scene("res://scenes/overworld/Main.tscn")
