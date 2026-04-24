extends CharacterBody3D
## PlayerController — Handles movement and camera following.

@export var move_speed: float = 5.0
@export var lerp_speed: float = 5.0
@export var camera_offset: Vector3 = Vector3(0, 3, 5)

@export_node_path("Node3D") var camera_rig
@export_node_path("Node3D") var mesh

var _camera: Node3D

func _ready() -> void:
	add_to_group("player")
	if camera_rig:
		_camera = get_node(camera_rig)
		# Detach camera so it follows with lerp
		_camera.top_level = true


func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_handle_camera(delta)


func _handle_movement(_delta: float) -> void:
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
		# Rotate mesh towards movement
		if mesh:
			var target_rot = atan2(-direction.x, -direction.z)
			get_node(mesh).rotation.y = lerp_angle(get_node(mesh).rotation.y, target_rot, 0.1)
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	move_and_slide()


func _handle_camera(delta: float) -> void:
	if _camera:
		var target_pos = global_position + camera_offset
		_camera.global_position = _camera.global_position.lerp(target_pos, lerp_speed * delta)
		_camera.look_at(global_position + Vector3.UP * 1.5)
