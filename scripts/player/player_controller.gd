extends CharacterBody3D
## PlayerController — Handles third-person movement, camera follow, interaction, and avatar animation.

@export var walk_speed: float = 4.0
@export var run_speed: float = 8.0
@export var left_stick_deadzone: float = 0.15
@export var camera_lerp_speed: float = 8.0
@export var camera_offset: Vector3 = Vector3(0, 3, 5)

@export_node_path("Node3D") var camera_rig
@export_node_path("Node3D") var mesh
@export_node_path("Area3D") var interact_radius
@export_node_path("Label3D") var interact_prompt

var _camera: Node3D
var _mesh_root: Node3D
var _interact_area: Area3D
var _prompt: Label3D
var _animation_player: AnimationPlayer
var _nearby_interactables: Array[Node] = []
var _current_animation := ""
var _gravity := ProjectSettings.get_setting("physics/3d/default_gravity") as float
var _interact_distance := 1.5

const STYLE_MODELS := {
	"explorer": "res://assets/models/kaykit_adventurers/Knight.glb",
	"builder": "res://assets/models/kaykit_adventurers/Barbarian.glb",
	"artist": "res://assets/models/kaykit_adventurers/Mage.glb",
	"guardian": "res://assets/models/kaykit_adventurers/Rogue_Hooded.glb"
}

func _ready() -> void:
	add_to_group("player")
	_mesh_root = get_node_or_null(mesh) as Node3D
	_interact_area = get_node_or_null(interact_radius) as Area3D
	_prompt = get_node_or_null(interact_prompt) as Label3D
	if camera_rig:
		_camera = get_node(camera_rig)
		_camera.top_level = true
	if _interact_area:
		_interact_area.body_entered.connect(_on_interact_body_entered)
		_interact_area.body_exited.connect(_on_interact_body_exited)
	if _prompt:
		_prompt.hide()
	_cache_interact_distance()
	_apply_avatar_model()
	_find_animation_player()
	_setup_active_wisp()


func _apply_avatar_model() -> void:
	if _mesh_root == null:
		return
	var body := _mesh_root.get_node_or_null("Body")
	if body is MeshInstance3D:
		body.hide()

	var style := "explorer"
	if SaveManager.active_profile != null:
		style = SaveManager.active_profile.avatar_style
	var model_path: String = STYLE_MODELS.get(style, STYLE_MODELS["explorer"])
	var existing := _mesh_root.get_node_or_null("AvatarModel")
	if existing != null and existing.scene_file_path == model_path:
		return
	if existing != null:
		existing.queue_free()

	var packed := load(model_path)
	if not (packed is PackedScene):
		if body is MeshInstance3D:
			body.show()
		return

	var avatar: Node3D = packed.instantiate()
	avatar.name = "AvatarModel"
	avatar.scale = Vector3.ONE * 0.9
	avatar.position = Vector3(0, 0.0, 0)
	_mesh_root.add_child(avatar)


func _find_animation_player() -> void:
	if _mesh_root == null:
		return
	_animation_player = _find_animation_player_recursive(_mesh_root)
	_play_animation("Idle")


func _find_animation_player_recursive(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer:
		return node
	for child in node.get_children():
		var found := _find_animation_player_recursive(child)
		if found != null:
			return found
	return null

func _setup_active_wisp() -> void:
	if SaveManager.active_profile and not SaveManager.active_profile.active_wisp_slots.is_empty():
		var slot_id = SaveManager.active_profile.active_wisp_slots[0]
		var wisp_data = WispRoster.get_wisp(slot_id)
		if wisp_data:
			var wisp_scene = load("res://scenes/npcs/wisp_entity.tscn")
			var wisp = wisp_scene.instantiate()
			get_parent().add_child(wisp)
			wisp.wisp_data_id = slot_id
			wisp.follow_target = get_path()
			wisp.update_from_wisp_data(wisp_data)


func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_handle_camera(delta)


func _process(_delta: float) -> void:
	_refresh_interactable_scan()
	_update_interact_prompt()
	_update_animation()


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("interact"):
		return
	var target := _nearest_interactable()
	if target == null and has_meta("interact_target"):
		target = get_meta("interact_target")
	if target != null and is_instance_valid(target):
		if target.has_method("interact"):
			target.call("interact")
		else:
			print("[Player] Interacted with %s" % target.name)
		get_viewport().set_input_as_handled()


func _handle_movement(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= _gravity * delta
	elif velocity.y < 0.0:
		velocity.y = 0.0

	var input_dir := _movement_vector()
	var direction := _camera_relative_direction(input_dir)
	var speed := run_speed if _is_running() else walk_speed

	if direction.length_squared() > 0.0:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		if _mesh_root:
			var target_rot := atan2(direction.x, direction.z)
			_mesh_root.rotation.y = lerp_angle(_mesh_root.rotation.y, target_rot, 12.0 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, walk_speed)
		velocity.z = move_toward(velocity.z, 0.0, walk_speed)

	move_and_slide()


func _handle_camera(delta: float) -> void:
	if _camera:
		var target_pos = global_position + camera_offset
		_camera.global_position = _camera.global_position.lerp(target_pos, camera_lerp_speed * delta)
		_camera.look_at(global_position + Vector3.UP * 1.5)


func _movement_vector() -> Vector2:
	var input_dir := Vector2.ZERO
	if InputMap.has_action("move_left") and InputMap.has_action("move_right") and InputMap.has_action("move_forward") and InputMap.has_action("move_back"):
		input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back", left_stick_deadzone)
	else:
		input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down", left_stick_deadzone)
	return input_dir if input_dir.length() >= left_stick_deadzone else Vector2.ZERO


func _camera_relative_direction(input_dir: Vector2) -> Vector3:
	if input_dir == Vector2.ZERO:
		return Vector3.ZERO
	var basis := global_transform.basis
	if _camera:
		basis = _camera.global_transform.basis
	var forward := -basis.z
	var right := basis.x
	forward.y = 0.0
	right.y = 0.0
	forward = forward.normalized()
	right = right.normalized()
	return (right * input_dir.x + forward * -input_dir.y).normalized()


func _is_running() -> bool:
	if Input.is_key_pressed(KEY_SHIFT):
		return true
	for device_id in Input.get_connected_joypads():
		if Input.get_joy_axis(device_id, JOY_AXIS_TRIGGER_LEFT) > 0.5:
			return true
	return false


func _on_interact_body_entered(body: Node3D) -> void:
	if body == self:
		return
	if _is_interactable(body) and not _nearby_interactables.has(body):
		_nearby_interactables.append(body)


func _on_interact_body_exited(body: Node3D) -> void:
	_nearby_interactables.erase(body)


func _cache_interact_distance() -> void:
	if _interact_area == null:
		return
	var shape_node := _interact_area.get_node_or_null("CollisionShape3D") as CollisionShape3D
	if shape_node != null and shape_node.shape is SphereShape3D:
		_interact_distance = (shape_node.shape as SphereShape3D).radius


func _refresh_interactable_scan() -> void:
	for candidate in get_tree().get_nodes_in_group("interactable"):
		if candidate == self or not (candidate is Node3D):
			continue
		var distance := global_position.distance_to((candidate as Node3D).global_position)
		if distance <= _interact_distance:
			if not _nearby_interactables.has(candidate):
				_nearby_interactables.append(candidate)
		else:
			_nearby_interactables.erase(candidate)


func _is_interactable(node: Node) -> bool:
	return node.has_method("interact") or node.is_in_group("interactable") or node.name.to_lower().contains("interactable")


func _nearest_interactable() -> Node:
	var nearest: Node = null
	var nearest_distance := INF
	for candidate in _nearby_interactables:
		if not is_instance_valid(candidate):
			continue
		if candidate is Node3D:
			var distance := global_position.distance_squared_to((candidate as Node3D).global_position)
			if distance < nearest_distance:
				nearest = candidate
				nearest_distance = distance
	return nearest


func _update_interact_prompt() -> void:
	if _prompt == null:
		return
	var target := _nearest_interactable()
	if target == null and has_meta("interact_target"):
		target = get_meta("interact_target")
	if target == null:
		_prompt.hide()
		return
	_prompt.text = "[X] Talk" if target.has_method("interact") else "[X] Pick Up"
	_prompt.show()


func _update_animation() -> void:
	if _animation_player == null:
		return
	var horizontal_speed := Vector2(velocity.x, velocity.z).length()
	if horizontal_speed < 0.1:
		_play_animation("Idle")
	elif horizontal_speed > walk_speed + 0.5:
		_play_animation("Running_A")
	else:
		_play_animation("Walking_A")


func _play_animation(animation_name: String) -> void:
	if _animation_player == null or _current_animation == animation_name:
		return
	if not _animation_player.has_animation(animation_name):
		return
	_current_animation = animation_name
	_animation_player.play(animation_name)
