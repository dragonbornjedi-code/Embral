extends Node
## In-memory registry of WispData by id (starter roster + runtime registration).

var _by_id: Dictionary = {}


func _ready() -> void:
	_seed_starter_wisps()


func register_wisp(data: WispData) -> void:
	if data and data.wisp_id != "":
		_by_id[data.wisp_id] = data


func get_wisp(id: String) -> WispData:
	var d: Variant = _by_id.get(id, null)
	return d as WispData


func _seed_starter_wisps() -> void:
	var flame := WispData.new()
	flame.wisp_id = "starter_fire"
	flame.element = "fire"
	flame.nickname = "Ember"
	flame.level = 1
	register_wisp(flame)

	var tide := WispData.new()
	tide.wisp_id = "starter_water"
	tide.element = "water"
	tide.nickname = "Ripple"
	tide.level = 1
	register_wisp(tide)

	var grove := WispData.new()
	grove.wisp_id = "starter_earth"
	grove.element = "earth"
	grove.nickname = "Moss"
	grove.level = 1
	register_wisp(grove)
