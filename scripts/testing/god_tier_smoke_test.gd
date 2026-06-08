extends Node

func _ready():
	# Small delay to ensure all autoloads have processed their _ready
	await get_tree().create_timer(0.5).timeout
	
	print("\n" + "═".repeat(40))
	print("  EMBRAL GOD-TIER SMOKE TEST")
	print("═".repeat(40))
	
	var success = true
	
	# 1. Autoload Check
	var required_autoloads = [
		"EventBus", "HardwareManager", "HABridge", "QuestManager", 
		"SaveManager", "TransitionManager", "DialogicStub", "ErrorLogger"
	]
	print("\n[1] Checking Autoloads...")
	for al in required_autoloads:
		if get_node_or_null("/root/" + al):
			print("  [OK] %s" % al)
		else:
			print("  [FAIL] %s is missing!" % al)
			success = false
			
	# 2. Plugin/GDExtension Check
	print("\n[2] Checking Plugins & GDExtensions...")
	if ClassDB.class_exists("Terrain3D"):
		print("  [OK] Terrain3D (GDExtension)")
	else:
		print("  [FAIL] Terrain3D not registered!")
		success = false
		
	if ClassDB.class_exists("BTPlayer"):
		print("  [OK] LimboAI (BTPlayer)")
	else:
		print("  [FAIL] LimboAI not registered!")
		success = false
		
	if Engine.has_singleton("Dialogic"):
		print("  [OK] Dialogic Singleton")
	else:
		# Dialogic might be an autoload instead of a singleton in 2.0
		if get_node_or_null("/root/Dialogic"):
			print("  [OK] Dialogic Autoload")
		else:
			print("  [WARN] Dialogic not found as singleton or autoload (checking stub...)")
			
	# 3. SaveManager Integrity
	print("\n[3] Checking SaveManager...")
	var sm = get_node_or_null("/root/SaveManager")
	if sm:
		var test_name = "smoke_test_ezra"
		var id = sm.create_profile(test_name)
		if sm.select_profile(id):
			if sm.active_profile and sm.active_profile.player_name == test_name:
				print("  [OK] Profile creation & activation")
				sm.delete_profile(id)
				print("  [OK] Profile deletion")
			else:
				print("  [FAIL] Active profile data mismatch")
				success = false
		else:
			print("  [FAIL] select_profile failed")
			success = false
	else:
		print("  [FAIL] SaveManager not found")
		success = false
	
	# 4. QuestManager Loading
	print("\n[4] Checking QuestManager...")
	var qm = get_node_or_null("/root/QuestManager")
	if qm:
		if qm.has_method("load_realm_quests"):
			print("  [OK] QuestManager methods accessible")
		else:
			print("  [FAIL] QuestManager missing methods")
			success = false
			
	print("\n" + "═".repeat(40))
	if success:
		print("  RESULT: SUCCESS")
		print("═".repeat(40) + "\n")
		# God-Tier Cleanup: Wait 2 frames to let engine finish internal teardown
		await get_tree().process_frame
		await get_tree().process_frame
		get_tree().quit(0)
	else:
		print("  RESULT: FAILURE")
		print("═".repeat(40) + "\n")
		await get_tree().process_frame
		get_tree().quit(1)
