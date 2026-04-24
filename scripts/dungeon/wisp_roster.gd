extends Node
## WispRoster — Utility to manage Wisp roster persistence.

class_name WispRoster

const ROSTER_PATH = "user://save/wisp_roster.json"

static func load_roster() -> Array[WispData]:
	if not FileAccess.file_exists(ROSTER_PATH):
		return []
	
	var file = FileAccess.open(ROSTER_PATH, FileAccess.READ)
	var parsed = JSON.parse_string(file.get_as_text())
	file.close()
	
	var roster: Array[WispData] = []
	if parsed is Array:
		for data in parsed:
			var wisp = WispData.new()
			wisp.from_dict(data)
			roster.append(wisp)
	return roster

static func save_roster(wisps: Array[WispData]) -> void:
	var data = []
	for wisp in wisps:
		data.append(wisp.to_dict())
	
	var file = FileAccess.open(ROSTER_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()

static func add_wisp(wisp: WispData) -> void:
	var roster = load_roster()
	roster.append(wisp)
	save_roster(roster)

static func get_wisp(wisp_id: String) -> WispData:
	var roster = load_roster()
	for wisp in roster:
		if wisp.wisp_id == wisp_id:
			return wisp
	return null
