extends Node2D
## DungeonBase — Base class for all 2D dungeon scenes.

class_name DungeonBase

@export var dungeon_id: String
@export var realm: String
@export var display_name: String

@onready var room_label = $DungeonHUD/RoomLabel

func _ready() -> void:
	add_to_group("dungeon")
	room_label.text = display_name

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		var scene_path := "res://scenes/overworld/%s/%s.tscn" % [realm, realm]
		if ResourceLoader.exists(scene_path):
			TransitionManager.change_scene(scene_path)
		else:
			push_error("[DungeonBase] Scene not found: %s" % scene_path)
			TransitionManager.change_scene("res://scenes/overworld/hearthveil/hearthveil.tscn")

func complete_dungeon() -> void:
	EventBus.dungeon_completed.emit(dungeon_id)
	EventBus.xp_gained.emit(50, "dungeon_clear")
	await get_tree().create_timer(2.0).timeout
	var scene_path := "res://scenes/overworld/%s/%s.tscn" % [realm, realm]
	if ResourceLoader.exists(scene_path):
		TransitionManager.change_scene(scene_path)
	else:
		push_error("[DungeonBase] Scene not found: %s" % scene_path)
		TransitionManager.change_scene("res://scenes/overworld/hearthveil/hearthveil.tscn")
