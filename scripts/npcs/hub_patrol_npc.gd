extends CharacterBody3D
## Hub patrol NPC — LimboAI selector: idle near player vs waypoint patrol; optional E dialogue.

const PatrolWaypoints := preload("res://ai/tasks/hub/patrol_waypoints.gd")
const PlayerWithinDistance := preload("res://ai/tasks/hub/player_within_distance.gd")
const HoldIdleNearPlayer := preload("res://ai/tasks/hub/hold_idle_near_player.gd")

const PLAYER_BB_KEY := &"player"

@export var npc_id: String = "hub_patrol_guide"

@onready var _bt_player: BTPlayer = $BTPlayer
@onready var _interaction_area: Area3D = $InteractionArea

var _player: Node3D
var _interact_label: Label3D
var _player_in_range: bool = false
var _talking: bool = false


func _ready() -> void:
	add_to_group("npcs")
	_player = get_tree().get_first_node_in_group("player") as Node3D
	_setup_interaction_ui()
	_setup_interaction_area()
	_bt_player.agent_node = NodePath("..")
	_bt_player.behavior_tree = _make_tree()
	_bt_player.active = true


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group("player") as Node3D
	if _bt_player.blackboard != null and is_instance_valid(_player):
		_bt_player.blackboard.set_var(PLAYER_BB_KEY, _player)


func _setup_interaction_ui() -> void:
	_interact_label = Label3D.new()
	_interact_label.text = "Press E to talk"
	_interact_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	_interact_label.position.y = 2.2
	_interact_label.no_depth_test = true
	_interact_label.hide()
	add_child(_interact_label)


func _setup_interaction_area() -> void:
	_interaction_area.body_entered.connect(_on_body_entered)
	_interaction_area.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	_player_in_range = true
	_interact_label.show()
	body.set_meta("interact_target", self)
	EventBus.npc_discovered.emit(npc_id)


func _on_body_exited(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	_player_in_range = false
	_interact_label.hide()
	if body.has_meta("interact_target") and body.get_meta("interact_target") == self:
		body.remove_meta("interact_target")


func interact() -> void:
	if _talking:
		return
	_talking = true
	_interact_label.hide()
	_bt_player.active = false
	velocity = Vector3.ZERO
	EventBus.npc_dialogue_started.emit(npc_id)
	var stub := get_node_or_null("/root/DialogicStub")
	if stub != null and stub.has_method(&"start_timeline"):
		stub.call(&"start_timeline", npc_id)
	else:
		print("[%s]: Hello, traveler." % npc_id)
	await get_tree().create_timer(1.2).timeout
	EventBus.npc_dialogue_ended.emit(npc_id)
	_bt_player.active = true
	_talking = false
	if _player_in_range:
		_interact_label.show()


func _make_tree() -> BehaviorTree:
	var patrol := PatrolWaypoints.new()
	patrol.patrol_points = PackedVector3Array([
		Vector3(-6.0, 0.0, -8.0),
		Vector3(6.0, 0.0, -8.0),
		Vector3(0.0, 0.0, -12.0),
	])
	patrol.move_speed = 2.5

	var repeat_patrol := BTRepeat.new()
	repeat_patrol.forever = true
	repeat_patrol.add_child(patrol)

	var near_cond := PlayerWithinDistance.new()
	near_cond.max_distance = 3.5
	var hold := HoldIdleNearPlayer.new()
	var near_branch := BTSequence.new()
	near_branch.add_child(near_cond)
	near_branch.add_child(hold)

	var root := BTSelector.new()
	root.add_child(near_branch)
	root.add_child(repeat_patrol)

	var tree := BehaviorTree.new()
	tree.root_task = root
	return tree
