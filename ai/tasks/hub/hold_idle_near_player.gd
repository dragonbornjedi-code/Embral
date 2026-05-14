extends BTAction
## While active, clears agent velocity so patrol does not fight this branch (returns RUNNING).

func _tick(_delta: float) -> BT.Status:
	var body := agent as CharacterBody3D
	if body == null:
		return BT.Status.FAILURE
	body.velocity = Vector3.ZERO
	body.move_and_slide()
	return BT.Status.RUNNING
