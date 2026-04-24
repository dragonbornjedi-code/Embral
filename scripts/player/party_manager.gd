extends Node

var player_wisp_slots: Array[String] = []
var companion_id: String = ""
var companion_wisp_slots: Array[String] = []

func get_traveling_party() -> Dictionary:
	return {
		"player_wisps": player_wisp_slots,
		"companion": companion_id,
		"companion_wisps": companion_wisp_slots
	}

func set_active_wisp(slot: int, wisp_id: String) -> void:
	if slot >= 0 and slot < 3:
		if player_wisp_slots.size() <= slot:
			player_wisp_slots.resize(slot + 1)
		player_wisp_slots[slot] = wisp_id
		if SaveManager.active_profile:
			SaveManager.active_profile.active_wisp_slots = player_wisp_slots
			SaveManager.save_current_profile()

func load_from_profile(profile: PlayerProfile) -> void:
	player_wisp_slots = profile.active_wisp_slots
	companion_id = profile.companion_id
