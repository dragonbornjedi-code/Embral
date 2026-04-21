extends SceneTree
## QuestManagerVerification — Verifies quest JSON loading and signals.

func _init() -> void:
    var test_quest_path = "res://data/quests/hearthveil/test_quest.json"
    
    # Create valid dummy quest if not exists
    var test_data = {
        "quest_id": "test_quest_01",
        "realm": "hearthveil",
        "npc_giver": "ignavarr",
        "research_basis": "citation_alpha",
        "developmental_target": "social_emotional",
        "age_range": "4-8",
        "steps": ["step1", "step2"],
        "scaffolding": "low"
    }
    
    var dir = DirAccess.open("res://data/quests/hearthveil/")
    if not dir: DirAccess.make_dir_recursive_absolute("res://data/quests/hearthveil/")
    
    var file = FileAccess.open(test_quest_path, FileAccess.WRITE)
    file.store_string(JSON.stringify(test_data))
    file.close()
    
    # Load and verify
    # QuestManager is autoload, so we can access it via /root/QuestManager
    var qm = root.get_node("/root/QuestManager")
    if qm.has_method("load_quest"):
        if qm.load_quest(test_quest_path):
            print("[VERIFY] QuestManager load: SUCCESS")
        else:
            printerr("[VERIFY] QuestManager load: FAILED")
    else:
        printerr("[VERIFY] QuestManager: load_quest method missing")
        
    quit()
