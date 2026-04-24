extends Node3D
## WispEntity — The visual representation of a Wisp in the overworld.

class_name WispEntity

@export var wisp_data_id: String = ""
@export var follow_target: NodePath = NodePath("")
@export var follow_speed: float = 3.0
@export var follow_distance: float = 1.5

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	add_to_group("wisp_entities")
	if wisp_data_id != "":
		var data = WispRoster.get_wisp(wisp_data_id)
		if data:
			update_from_wisp_data(data)

func _physics_process(delta: float) -> void:
	if follow_target:
		var target = get_node_or_null(follow_target)
		if target and global_position.distance_to(target.global_position) > follow_distance:
			global_position = global_position.lerp(target.global_position, follow_speed * delta)

func update_from_wisp_data(data: WispData) -> void:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = data.get_element_color()
	mesh_instance.material_override = mat
