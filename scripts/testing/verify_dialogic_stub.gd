extends SceneTree

func _init() -> void:
	print("--- Starting DialogicStub Verification ---")
	
	# Wait for autoloads
	await process_frame
	
	var stub = root.get_node("/root/DialogicStub")
	if stub == null:
		printerr("FAILED: DialogicStub autoload not found.")
		quit(1)
		return
		
	# Create a dummy fallback for test_npc
	var npc_id = "test_npc"
	var fallback_path = "res://data/dialogue/" + npc_id + "_fallback.json"
	var fallback_data = {
		"npc_id": npc_id,
		"lines": ["Hello, this is a fallback line for verification."],
		"no_quest_line": "No quest for you!"
	}
	
	var dir = DirAccess.open("res://")
	if not dir.dir_exists("data/dialogue"):
		dir.make_dir_recursive("data/dialogue")
		
	var file = FileAccess.open(fallback_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(fallback_data))
	file.close()
	
	print("Testing timeline launch for test_npc...")
	var line = stub.start_timeline(npc_id)
	
	if stub.is_available():
		print("Dialogic available. Timeline should be launched.")
		# We can't easily check if a timeline is launched headless, but it didn't crash.
		if line == "":
			print("VERIFIED: Dialogic handled the timeline.")
		else:
			print("FAILED: Dialogic available but stub returned fallback line.")
	else:
		print("Dialogic NOT available. Fallback expected.")
		if line == "Hello, this is a fallback line for verification.":
			print("VERIFIED: Correct fallback line returned.")
		else:
			print("FAILED: Wrong fallback line returned: ", line)
			
	quit()
