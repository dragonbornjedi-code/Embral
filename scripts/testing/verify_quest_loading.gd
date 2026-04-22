extends SceneTree

func _init() -> void:
	print("--- Starting QuestManager Loading Test ---")
	
	# Wait for autoloads to be initialized
	await process_frame
	
	var quest_manager = root.get_node("/root/QuestManager")
	if quest_manager == null:
		printerr("FAILED: QuestManager autoload not found.")
		quit(1)
		return
		
	print("Attempting to load Hearthveil quests...")
	quest_manager.load_realm_quests("hearthveil")
	
	# Wait another frame just in case (though loading is synchronous)
	await process_frame
	
	var quests = quest_manager._quests
	print("Quests loaded count: ", quests.size())
	
	if quests.size() > 0:
		print("Successfully loaded quests: ", quests.keys())
		# Check if test_quest_01 is there
		if quests.has("test_quest_01"):
			print("VERIFIED: test_quest_01 loaded successfully.")
		else:
			print("FAILED: test_quest_01 not found.")
	else:
		print("FAILED: No quests loaded.")
		
	quit()
