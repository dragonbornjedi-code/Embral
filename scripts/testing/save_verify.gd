extends SceneTree
## SaveManagerVerification — Verifies SaveManager write/read cycle.

func _init() -> void:
    var test_data = {"level": 5, "xp": 100}
    var path = "user://save/test_verify.json"
    
    # Ensure dir exists
    DirAccess.make_dir_recursive_absolute("user://save/")
    
    # Write
    var file = FileAccess.open(path, FileAccess.WRITE)
    file.store_string(JSON.stringify(test_data))
    file.close()
    
    # Read
    file = FileAccess.open(path, FileAccess.READ)
    var content = file.get_as_text()
    file.close()
    
    var result = JSON.parse_string(content)
    
    if result and result.level == 5 and result.xp == 100:
        print("[VERIFY] SaveManager write/read: SUCCESS")
    else:
        printerr("[VERIFY] SaveManager write/read: FAILED")
    
    quit()
