extends BTAction
## LimboAI task: move CharacterBody3D agent between XY-aligned waypoints on the ground plane.

@export var patrol_points: PackedVector3Array = PackedVector3Array()
@export var waypoint_radius: float = 0.45
@export var move_speed: float = 2.5

var _idx: int = 0


func _tick(_delta: float) -> BT.Status:
	var body := agent as CharacterBody3D
	if body == null:
		return BT.Status.FAILURE
	if patrol_points.is_empty():
		return BT.Status.FAILURE

	var target: Vector3 = patrol_points[_idx % patrol_points.size()]
	var pos := body.global_position
	var to_xz := Vector3(target.x - pos.x, 0.0, target.z - pos.z)
	if to_xz.length() <= waypoint_radius:
		_idx = (_idx + 1) % patrol_points.size()
		body.velocity = Vector3.ZERO
		return BT.Status.SUCCESS

	body.velocity = to_xz.normalized() * move_speed
	body.move_and_slide()
	return BT.Status.RUNNING
