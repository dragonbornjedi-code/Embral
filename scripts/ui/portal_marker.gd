extends Node3D
class_name PortalMarker

@export var target_realm: String = ""
@export var required_level: int = 1
@export var required_npc_discoveries: int = 3
@export var is_unlocked: bool = false
@export var is_trial_portal: bool = false
@export var target_path: String = ""

@onready var portal_label: Label3D = $PortalLabel
@onready var interaction_area: Area3D = $InteractionArea

func _ready() -> void:
    EventBus.realm_unlocked.connect(_on_realm_unlocked)
    _check_unlock()
    interaction_area.body_entered.connect(_on_body_entered)
    interaction_area.body_exited.connect(_on_body_exited)

func _check_unlock() -> void:
    if required_npc_discoveries <= 0:
        is_unlocked = true
    elif SaveManager.active_profile:
        var discovery_count = QuestManager.get_npc_discovery_count(target_realm)
        is_unlocked = (discovery_count >= required_npc_discoveries and SaveManager.active_profile.level >= required_level)
    else:
        is_unlocked = false
    
    if is_unlocked:
        if target_path != "" and target_realm == "hearthveil":
            portal_label.text = "Return to Hearthveil"
        else:
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
        if is_unlocked:
            interact()

func _on_body_exited(body: Node3D) -> void:
    if body.is_in_group("player") and body.has_meta("interact_target") and body.get_meta("interact_target") == self:
        body.remove_meta("interact_target")

func interact() -> void:
    if is_unlocked:
        var path := _target_scene_path()
        if ResourceLoader.exists(path):
            TransitionManager.change_scene(path)
        else:
            push_error("[PortalMarker] Scene not found: %s" % path)
    else:
        print("[Portal] Locked — discover more friends first!")


func _target_scene_path() -> String:
    if target_path != "":
        return target_path
    if is_trial_portal:
        return "res://scenes/trials/%s.tscn" % target_realm
    return "res://scenes/overworld/%s/%s.tscn" % [target_realm, target_realm]
