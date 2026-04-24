extends Node
## TransitionManager — Global scene transition controller.
## Handles smooth fade-out → load → fade-in sequence.

const OVERLAY_SCENE = preload("res://scenes/effects/transition_overlay.tscn")

var _overlay: CanvasLayer
var _rect: ColorRect

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_overlay = OVERLAY_SCENE.instantiate()
	add_child(_overlay)
	_rect = _overlay.get_node("ColorRect")


## Change scene with a smooth fade sequence.
func change_scene(path: String, data: Dictionary = {}) -> void:
	# 1. Fade to black
	var tween_out = create_tween()
	tween_out.tween_property(_rect, "color:a", 1.0, 0.3).set_trans(Tween.TRANS_SINE)
	await tween_out.finished
	
	# 2. Load new scene
	var err = get_tree().change_scene_to_file(path)
	if err != OK:
		push_error("[TransitionManager] Failed to load scene: %s (Error %d)" % [path, err])
		# Attempt to recover by fading back in anyway
	
	# 3. Fade back in
	var tween_in = create_tween()
	tween_in.tween_property(_rect, "color:a", 0.0, 0.3).set_trans(Tween.TRANS_SINE)
	await tween_in.finished
	
	# 4. Notify ecosystem
	EventBus.scene_changed.emit(path, data)
