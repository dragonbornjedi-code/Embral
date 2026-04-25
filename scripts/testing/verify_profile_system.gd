extends SceneTree

func _init() -> void:
	print("--- Starting ProfileSystem Verification ---")
	
	await process_frame
	
	var sm = root.get_node("/root/SaveManager")
	if sm == null:
		printerr("FAILED: SaveManager not found.")
		quit(1)
		return
		
	# Clean start for test
	var profiles = sm.get_profile_list()
	for p in profiles.duplicate():
		sm.delete_profile(p["id"])
		
	print("Testing profile creation...")
	var id1 = sm.create_profile("Player")
	var id2 = sm.create_profile("Lyra")
	
	profiles = sm.get_profile_list()
	print("Profiles count: ", profiles.size())
	if profiles.size() == 2:
		print("VERIFIED: 2 profiles created.")
	else:
		print("FAILED: Expected 2 profiles, got ", profiles.size())
		
	print("Testing profile selection...")
	if sm.select_profile(id1):
		print("VERIFIED: Profile selected: ", sm.active_profile.player_name)
		if sm.active_profile.player_name == "Player":
			print("VERIFIED: Correct profile data loaded.")
		else:
			print("FAILED: Wrong profile data loaded.")
	else:
		print("FAILED: Profile selection failed.")
		
	print("Testing quest completion save...")
	sm.mark_quest_complete("test_quest_01", 0.95)
	if sm.is_quest_complete("test_quest_01"):
		print("VERIFIED: Quest marked complete.")
	else:
		print("FAILED: Quest not marked complete.")
		
	# Switch profile and check
	print("Switching profile...")
	sm.select_profile(id2)
	if not sm.is_quest_complete("test_quest_01"):
		print("VERIFIED: Quest completion is profile-specific.")
	else:
		print("FAILED: Quest completion leaked to other profile.")
		
	# Delete and check
	print("Testing profile deletion...")
	sm.delete_profile(id1)
	profiles = sm.get_profile_list()
	if profiles.size() == 1 and profiles[0]["id"] == id2:
		print("VERIFIED: Profile deleted correctly.")
	else:
		print("FAILED: Profile deletion failed.")
		
	quit()
