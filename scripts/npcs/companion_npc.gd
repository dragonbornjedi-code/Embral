extends BaseNPC
## CompanionNPC — Base class for Companions (second avatars).
## Handles switching between AI follow and player control.

class_name CompanionNPC

@export_group("Companion Data")
@export var is_player_controlled: bool = false
@export var move_speed: float = 4.5
@export var follow_distance: float = 2.0

var follow_target: Node3D = null

func _ready() -> void:
	super._ready()
	add_to_group("companion_npc")
	
	# Connect to controller signals if they exist
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	
	# Set follow target to player by default
	_find_player()


func _find_player() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if not players.is_empty():
		follow_target = players[0]


func _physics_process(delta: float) -> void:
	if is_player_controlled:
		_handle_player_control(delta)
	else:
		_handle_ai_follow(delta)


func _handle_player_control(_delta: float) -> void:
	# Simplified movement for player 2
	var input_dir = Input.get_vector("p2_left", "p2_right", "p2_up", "p2_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	move_and_slide()


func _handle_ai_follow(_delta: float) -> void:
	if not follow_target:
		_find_player()
		return
		
	var dist = global_position.distance_to(follow_target.global_position)
	if dist > follow_distance:
		var dir = (follow_target.global_position - global_position).normalized()
		velocity.x = dir.x * move_speed
		velocity.z = dir.z * move_speed
		look_at(follow_target.global_position, Vector3.UP)
		rotation.x = 0
		rotation.z = 0
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)
		
	move_and_slide()


func _on_joy_connection_changed(device: int, connected: bool) -> void:
	if device > 0: # Assume device 0 is player 1
		if connected:
			_on_controller_connected()
		else:
			_on_controller_disconnected()


func _on_controller_connected() -> void:
	is_player_controlled = true
	print("[Companion] Controller connected. Player 2 taking control.")


func _on_controller_disconnected() -> void:
	is_player_controlled = false
	print("[Companion] Controller disconnected. Returning to AI follow.")
