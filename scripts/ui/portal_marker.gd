extends Node
## PortalMarker — Handles transition to new realms.

class_name PortalMarker

@export var target_realm: String = ""
@export var required_level: int = 1
@export var required_npc_discoveries: int = 0
@export var is_unlocked: bool = false
@export var is_trial_portal: bool = false

@onready var portal_label: Label3D = $PortalLabel
@onready var interaction_area: Area3D = $InteractionArea

func _ready() -> void:
	EventBus.realm_unlocked.connect(_on_realm_unlocked)
	EventBus.npc_mastery_level_up.connect(func(_id, _lvl): _check_unlock())
	_check_unlock()
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)
	
	var shape = interaction_area.get_node_or_null("CollisionShape3D")
	if shape == null:
		push_error("[PortalMarker] InteractionArea missing CollisionShape3D on %s" % name)

func _check_unlock() -> void:
	if not SaveManager.active_profile:
		is_unlocked = false
	else:
		var discovery_count = QuestManager.get_npc_discovery_count(target_realm)
		var player_level = SaveManager.active_profile.level
		is_unlocked = (discovery_count >= required_npc_discoveries and player_level >= required_level)
	
	if is_unlocked:
		if is_trial_portal:
			portal_label.text = "⚡ Trial Ready!"
		else:
			portal_label.text = target_realm.replace("_", " ").capitalize()
		portal_label.modulate = Color.WHITE
	else:
		if is_trial_portal:
			portal_label.text = "Trial: %d/3 friends found" % QuestManager.get_npc_discovery_count(target_realm)
		else:
			portal_label.text = "Locked"
		portal_label.modulate = Color.GRAY

func _on_realm_unlocked(realm_id: String) -> void:
	if realm_id == target_realm:
		is_unlocked = true
		_check_unlock()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.set_meta("interact_target", self)

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		if body.get_meta("interact_target") == self:
			body.remove_meta("interact_target")

func interact() -> void:
	if is_unlocked:
		var path = ""
		if is_trial_portal:
			path = "res://scenes/trials/%s.tscn" % target_realm
		else:
			path = "res://scenes/overworld/%s/%s.tscn" % [target_realm, target_realm]
			
		if ResourceLoader.exists(path):
			TransitionManager.change_scene(path)
		else:
			push_error("[PortalMarker] Scene not found: %s" % path)
	else:
		print("[Portal] Locked — discover more friends first!")
