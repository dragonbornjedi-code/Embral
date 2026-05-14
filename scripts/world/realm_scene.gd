extends Node3D

@export var realm_id: String = ""
@export var display_name: String = ""
@export var realm_color: Color = Color(0.4, 0.6, 0.8)

const PLAYER_SCENE := preload("res://scenes/player/Player.tscn")
const HUD_SCENE := preload("res://scenes/ui/PlayerHUD.tscn")
const QUEST_GIVER_SCENE := preload("res://scenes/npcs/QuestGiverBase.tscn")
const PORTAL_SCRIPT := preload("res://scripts/ui/portal_marker.gd")
const NPC_MODEL_SCENE := preload("res://assets/models/kaykit_adventurers/Mage.glb")

var _npcs_by_realm := {
	"ember_hollow": [["ember_ember", "Ember", "Hello, {player}! Can you tell me how you feel today?"], ["ember_kind", "Kind", "Small acts of kindness light up the whole world."], ["ember_mirror", "Mirror", "Let's practice seeing through someone else's eyes."], ["ember_soothe", "Soothe", "Breathe in slowly with me, then breathe out."]],
	"tidemark": [["tide_letter", "Alphabet Alga", "Letters float everywhere in the tide."], ["tide_sound", "Phonic Pearl", "Listen closely. Every letter has a sound."], ["tide_word", "Sight-Word Seahorse", "Words are easier when we spot them often."], ["tide_story", "Narrative Nautilus", "Tell me what happens next in the story."]],
	"forge_run": [["forge_balance", "Steady Stone", "Stand tall and find your balance."], ["forge_build", "Construction Coal", "One block at a time builds strong hands."], ["forge_dance", "Sparky Step", "Move to the beat and feel your body work."], ["forge_throw", "Aiming Ash", "Ready, set, aim. Focus before you throw."]],
	"rootstead": [["root_chores", "Helper Hedge", "Helping makes the whole home feel better."], ["root_food", "Berry Bite", "Colorful food helps your body grow strong."], ["root_hygiene", "Sparkle Sprout", "Clean hands keep adventures healthy."], ["root_time", "Tock Tulip", "Routines help us know what comes next."]],
	"the_spire": [["spire_numbers", "Plus Pixie", "Numbers can climb like stairs."], ["spire_math", "Count Cloud", "Let's count what we can see from up high."], ["spire_plants", "Flora Fly", "Plants need care, light, and water."], ["spire_weather", "Windy Willow", "Weather changes. We can observe it together."]],
	"the_drift": [["drift_draw", "Sketchy Smoke", "Draw what you imagine."], ["drift_build", "Maker Mist", "Let's build an idea into something real."], ["drift_music", "Rhythm Rain", "Clap with the beat."], ["drift_story", "Comic Cloud", "Every silly story needs a beginning."]]
}

const TUTORIAL_STARTER_QUESTS := {
	"ember_hollow": "EH_EMO_001",
	"tidemark": "TM_LET_001",
	"forge_run": "FR_BAL_001",
	"rootstead": "RS_CHO_001",
	"the_spire": "SP_NUM_001",
	"the_drift": "DR_ART_001"
}

const TUTORIAL_STARTER_NPCS := {
	"ember_hollow": "ember_ember",
	"tidemark": "tide_letter",
	"forge_run": "forge_balance",
	"rootstead": "root_chores",
	"the_spire": "spire_numbers",
	"the_drift": "drift_draw"
}

var _tutorial_realm_quest_active := false


func _ready() -> void:
	_setup_environment()
	_setup_lighting()
	_setup_ground_color()
	_ensure_platforms()
	_ensure_boundary_walls()
	_spawn_player()
	_spawn_hud()
	_spawn_realm_label()
	_spawn_npcs()
	_spawn_return_portal()
	_setup_tutorial_realm_quest()


func _setup_ground_color() -> void:
	var ground := get_node_or_null("Ground")
	if ground is MeshInstance3D:
		var mat := StandardMaterial3D.new()
		mat.albedo_color = _theme_ground_color()
		ground.set_surface_override_material(0, mat)


func _setup_environment() -> void:
	var world_environment := get_node_or_null("WorldEnvironment") as WorldEnvironment
	if world_environment == null:
		return
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = _theme_sky_color()
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = _theme_sky_color()
	environment.ambient_light_energy = 0.75
	world_environment.environment = environment


func _setup_lighting() -> void:
	var light := get_node_or_null("DirectionalLight3D") as DirectionalLight3D
	if light == null:
		return
	light.rotation_degrees = Vector3(-45, -35, 0)
	light.light_color = _theme_light_color()
	light.light_energy = 1.6
	light.shadow_enabled = true


func _ensure_platforms() -> void:
	if has_node("Platforms"):
		return
	var platforms := Node3D.new()
	platforms.name = "Platforms"
	add_child(platforms)
	var platform_data: Array[Dictionary] = [
		{"name": "Platform1", "position": Vector3(-10, 0.35, -8), "size": Vector3(6, 0.7, 5)},
		{"name": "Platform2", "position": Vector3(9, 0.55, -7), "size": Vector3(5, 1.1, 5)},
		{"name": "Platform3", "position": Vector3(-12, 0.25, 8), "size": Vector3(4, 0.5, 7)},
		{"name": "Platform4", "position": Vector3(10, 0.75, 8), "size": Vector3(7, 1.5, 4)},
		{"name": "Platform5", "position": Vector3(0, 0.45, -13), "size": Vector3(5, 0.9, 4)}
	]
	for item: Dictionary in platform_data:
		platforms.add_child(_make_platform(str(item["name"]), item["position"], item["size"]))


func _make_platform(platform_name: String, platform_position: Vector3, platform_size: Vector3) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = platform_name
	body.position = platform_position

	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = platform_size
	mesh_instance.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = _theme_ground_color().lerp(Color.WHITE, 0.18)
	mesh_instance.set_surface_override_material(0, material)
	body.add_child(mesh_instance)

	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = platform_size
	collision.shape = shape
	body.add_child(collision)
	return body


func _ensure_boundary_walls() -> void:
	if has_node("BoundaryWalls"):
		return
	var walls := Node3D.new()
	walls.name = "BoundaryWalls"
	add_child(walls)
	_add_boundary_wall(walls, "NorthWall", Vector3(0, 2, -20), Vector3(40, 4, 0.5))
	_add_boundary_wall(walls, "SouthWall", Vector3(0, 2, 20), Vector3(40, 4, 0.5))
	_add_boundary_wall(walls, "WestWall", Vector3(-20, 2, 0), Vector3(0.5, 4, 40))
	_add_boundary_wall(walls, "EastWall", Vector3(20, 2, 0), Vector3(0.5, 4, 40))


func _add_boundary_wall(parent: Node3D, wall_name: String, wall_position: Vector3, wall_size: Vector3) -> void:
	var wall := StaticBody3D.new()
	wall.name = wall_name
	wall.position = wall_position
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = wall_size
	collision.shape = shape
	wall.add_child(collision)
	parent.add_child(wall)


func _spawn_player() -> void:
	if get_tree().get_first_node_in_group("player") != null:
		return
	var player := PLAYER_SCENE.instantiate()
	var spawn := get_node_or_null("PlayerSpawn")
	add_child(player)
	player.global_position = spawn.global_position if spawn is Node3D else Vector3(0, 1, 5)


func _spawn_hud() -> void:
	if get_node_or_null("PlayerHUD") != null:
		return
	var hud := HUD_SCENE.instantiate()
	hud.name = "PlayerHUD"
	add_child(hud)
	if hud.has_method("set_hub_objective"):
		hud.call("set_hub_objective", "Explore %s. Talk to each guide, then use the Hearthveil portal." % display_name)


func _spawn_realm_label() -> void:
	var label := Label3D.new()
	label.name = "RealmTitle"
	label.text = display_name
	label.position = Vector3(0, 3.2, -8)
	label.pixel_size = 0.02
	label.font_size = 72
	label.outline_size = 12
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(label)


func _spawn_npcs() -> void:
	var npcs: Array = _npcs_by_realm.get(realm_id, [])
	var positions: Array[Vector3] = [Vector3(0, 0, -6), Vector3(-9, 0, 1), Vector3(9, 0, 1), Vector3(12, 0, -7)]
	for i in range(npcs.size()):
		var npc := QUEST_GIVER_SCENE.instantiate()
		npc.name = "StarterNPC" if i == 0 else "Guide_%d" % i
		npc.position = positions[i]
		npc.npc_id = npcs[i][0]
		npc.npc_name = npcs[i][1]
		npc.greeting = npcs[i][2]
		npc.quest_offer = "Practice with me, then explore the next guide."
		npc.quest_complete = "Great work."
		npc.no_quests = "You can come back and practice any time."
		add_child(npc)
		_configure_npc_visual(npc, str(npcs[i][1]))


func _configure_npc_visual(npc: Node, npc_display_name: String) -> void:
	var primitive_visual := npc.get_node_or_null("MeshInstance3D") as Node3D
	if primitive_visual != null:
		primitive_visual.visible = false
	if npc.get_node_or_null("KayKitModel") == null:
		var model := NPC_MODEL_SCENE.instantiate() as Node3D
		model.name = "KayKitModel"
		model.scale = Vector3(1.1, 1.1, 1.1)
		model.rotation_degrees = Vector3(0, 180, 0)
		npc.add_child(model)
	var label := npc.get_node_or_null("Label3D") as Label3D
	if label != null:
		label.text = npc_display_name
		label.position = Vector3(0, 2.2, 0)
		label.pixel_size = 0.015
		label.font_size = 48
		label.outline_size = 8
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED


func _setup_tutorial_realm_quest() -> void:
	if SaveManager.active_profile == null or SaveManager.active_profile.tutorial_completed:
		return
	if not SaveManager.active_profile.tutorial_intro_completed:
		return
	if SaveManager.active_profile.tutorial_realms_completed.has(realm_id):
		_set_objective("You already helped here. Use the Hearthveil portal to choose another realm.")
		return
	var quest_id: String = TUTORIAL_STARTER_QUESTS.get(realm_id, "")
	if quest_id == "":
		return
	QuestManager.load_realm_quests(realm_id)
	QuestManager.start_quest(quest_id)
	_tutorial_realm_quest_active = true
	if not EventBus.npc_dialogue_started.is_connected(_on_tutorial_npc_dialogue_started):
		EventBus.npc_dialogue_started.connect(_on_tutorial_npc_dialogue_started)
	_set_objective("Tutorial realm quest: talk to %s, then return to Hearthveil." % _first_npc_display_name())


func _on_tutorial_npc_dialogue_started(npc_id: String) -> void:
	if not _tutorial_realm_quest_active:
		return
	if npc_id != TUTORIAL_STARTER_NPCS.get(realm_id, ""):
		return
	QuestManager.complete_step()
	if SaveManager.active_profile != null and not SaveManager.active_profile.tutorial_realms_completed.has(realm_id):
		SaveManager.active_profile.tutorial_realms_completed.append(realm_id)
		SaveManager.save_current_profile()
	_tutorial_realm_quest_active = false
	_set_objective("Great. Use the glowing Hearthveil portal to return to Ignavarr.")


func _set_objective(text: String) -> void:
	var hud := get_node_or_null("PlayerHUD")
	if hud != null and hud.has_method("set_hub_objective"):
		hud.call("set_hub_objective", text)


func _first_npc_display_name() -> String:
	var npcs: Array = _npcs_by_realm.get(realm_id, [])
	if npcs.is_empty():
		return "the first guide"
	return str(npcs[0][1])


func _spawn_return_portal() -> void:
	var portal := Node3D.new()
	portal.name = "ReturnPortal"
	portal.position = Vector3(0, 0.2, 8)
	portal.set_script(PORTAL_SCRIPT)
	portal.target_realm = "hearthveil"
	portal.target_path = "res://scenes/overworld/hearthveil/HubWorld.tscn"
	portal.required_npc_discoveries = 0
	portal.is_unlocked = true

	var arch := MeshInstance3D.new()
	arch.name = "PortalArch"
	var mesh := TorusMesh.new()
	mesh.inner_radius = 0.75
	mesh.outer_radius = 1.15
	arch.mesh = mesh
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.9, 0.92, 0.95)
	mat.emission_enabled = true
	mat.emission = Color(0.9, 0.95, 1.0)
	mat.emission_energy_multiplier = 0.9
	arch.set_surface_override_material(0, mat)
	portal.add_child(arch)

	var light := OmniLight3D.new()
	light.name = "OmniLight3D"
	light.light_color = Color(0.9, 0.95, 1.0)
	light.light_energy = 2.0
	light.omni_range = 4.0
	light.position = Vector3(0, 1.2, 0)
	portal.add_child(light)

	var label := Label3D.new()
	label.name = "PortalLabel"
	label.text = "Return to Hearthveil"
	label.position = Vector3(0, 2.2, 0)
	label.pixel_size = 0.015
	label.font_size = 48
	label.outline_size = 10
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	portal.add_child(label)

	var area := Area3D.new()
	area.name = "InteractionArea"
	area.collision_layer = 0
	area.collision_mask = 2
	portal.add_child(area)

	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(4, 3, 4)
	shape.shape = box
	shape.position = Vector3(0, 1.5, 0)
	area.add_child(shape)
	add_child(portal)


func _theme_ground_color() -> Color:
	match realm_id:
		"ember_hollow":
			return Color.html("#8B3A1A")
		"tidemark":
			return Color.html("#1A4A6B")
		"forge_run":
			return Color.html("#3A3A3A")
		"rootstead":
			return Color.html("#2A5A1A")
		"the_spire":
			return Color.html("#3A1A6B")
		"the_drift":
			return Color.html("#6AAFC8")
		_:
			return realm_color


func _theme_sky_color() -> Color:
	match realm_id:
		"ember_hollow":
			return Color.html("#FF6B35")
		"tidemark":
			return Color.html("#2AB5C8")
		"forge_run":
			return Color.html("#888888")
		"rootstead":
			return Color.html("#5A9A2A")
		"the_spire":
			return Color.html("#8A3AC8")
		"the_drift":
			return Color.html("#87CEEB")
		_:
			return Color(0.4, 0.6, 0.8)


func _theme_light_color() -> Color:
	match realm_id:
		"ember_hollow":
			return Color.html("#FFB36B")
		"tidemark":
			return Color.html("#8CEFFF")
		"forge_run":
			return Color.html("#F0F4FF")
		"rootstead":
			return Color.html("#B7F08A")
		"the_spire":
			return Color.html("#C28CFF")
		"the_drift":
			return Color.html("#F4FBFF")
		_:
			return Color.WHITE
