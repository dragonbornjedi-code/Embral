extends Node
## Boot — Initial project health check and loading sequence.
## Verifies that all critical autoloads are present and functioning.

func _ready() -> void:
	print("--- Embral Foundation Health Check ---")
	
	var critical_autoloads := [
		"EventBus",
		"HardwareManager",
		"HABridge",
		"QuestManager",
		"ConfigLoader",
		"SaveManager"
	]
	
	var all_ok := true
	for singleton in critical_autoloads:
		if has_node("/root/" + singleton):
			print("[OK] %s is active." % singleton)
		else:
			printerr("[FAIL] %s is MISSING from root." % singleton)
			all_ok = false
	
	if all_ok:
		print("[SUCCESS] All core systems verified.")
		# Defer scene changes until the current tree mutation is complete.
		_load_main_menu.call_deferred()
	else:
		printerr("[FATAL] Foundation failure. Check project.godot autoloads.")

func _load_main_menu() -> void:
	print("[BOOT] Transitioning to Main Menu...")
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
