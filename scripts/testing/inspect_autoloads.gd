extends SceneTree

func _init() -> void:
	print("--- Autoload Inspection ---")
	await process_frame
	for child in root.get_children():
		print("Child: ", child.name, " (", child.get_class(), ")")
	quit()
