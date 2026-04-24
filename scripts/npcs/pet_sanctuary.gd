extends Node3D
## PetSanctuary — Interactive home for Ezra's pets.

func _ready() -> void:
	$SanctuaryEntrance.body_entered.connect(_on_player_entered)

func _on_player_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		# Using a stubbed loading pattern as we don't have a fully populated pet roster yet.
		var roster = [] # Logic to load from SaveManager would go here
		if roster.is_empty():
			print("You don't have any pets yet! Complete quests to find one.")
		else:
			$PetMinigame.open(roster[0])
