extends BTCondition
## Succeeds when the blackboard holds a valid `player` Node3D within max_distance of the agent.

@export var max_distance: float = 4.0

const PLAYER_KEY := &"player"


func _tick(_delta: float) -> BT.Status:
	var body := agent as Node3D
	if body == null:
		return BT.Status.FAILURE
	var player: Node3D = blackboard.get_var(PLAYER_KEY, null) as Node3D
	if not is_instance_valid(player):
		return BT.Status.FAILURE
	if body.global_position.distance_to(player.global_position) <= max_distance:
		return BT.Status.SUCCESS
	return BT.Status.FAILURE
