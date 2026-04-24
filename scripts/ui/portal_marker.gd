extends Node3D
class_name PortalMarker

@export var target_realm: String = ""
@export var required_level: int = 1
@export var required_npc_discoveries: int = 3
@export var is_unlocked: bool = false
@export var is_trial_portal: bool = false

@onready var portal_label: Label3D = $PortalLabel
@onready var interaction_area: Area3D = $InteractionArea

func _ready() -> void:
    EventBus.realm_unlocked.connect(_on_realm_unlocked)
    _check_unlock()
    interaction_area.body_entered.connect(_on_body_entered)

func _check_unlock() -> void:
    if SaveManager.active_profile:
        var discovery_count = QuestManager.get_npc_discovery_count(target_realm)
        is_unlocked = (discovery_count >= required_npc_discoveries and SaveManager.active_profile.level >= required_level)
    else:
        is_unlocked = false
    
    if is_unlocked:
        portal_label.text = "⚡ Trial Ready!" if is_trial_portal else target_realm.replace("_", " ").capitalize()
        portal_label.modulate = Color.WHITE
    else:
        var count = QuestManager.get_npc_discovery_count(target_realm)
        portal_label.text = "Trial: %d/3 friends found" % count
        portal_label.modulate = Color.GRAY

func _on_realm_unlocked(realm_id: String) -> void:
    if realm_id == target_realm:
        is_unlocked = true
        _check_unlock()

func _on_body_entered(body: Node3D) -> void:
    if body.is_in_group("player"):
        body.set_meta("interact_target", self)

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
