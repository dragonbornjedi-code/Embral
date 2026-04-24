extends Node2D
## PetMinigame — Interaction hub for pet care at the Player's House.

class_name PetMinigame

@export var pet_data: PetData

@onready var pet_name_label = $PetArea/PetName
@onready var happiness_label = $PetArea/HappinessBar
@onready var hunger_label = $PetArea/HungerBar

func open(data: PetData) -> void:
	pet_data = data
	pet_data.tick_hunger()
	_refresh_ui()
	show()

func _refresh_ui() -> void:
	if not pet_data: return
	pet_name_label.text = pet_data.nickname
	
	var hap = ""
	match pet_data.get_happiness_label():
		"Happy": hap = "😊 Happy"
		"Content": hap = "😐 Content"
		_: hap = "😢 Sad"
	happiness_label.text = hap
	
	var hun = ""
	if pet_data.hunger >= 80: hun = "🍎 Full"
	elif pet_data.hunger >= 40: hun = "😋 Hungry"
	else: hun = "😰 Starving"
	hunger_label.text = hun

func _on_feed_button_pressed() -> void:
	if pet_data:
		pet_data.hunger = min(100, pet_data.hunger + 20)
		_refresh_ui()

func _on_play_button_pressed() -> void:
	if pet_data:
		pet_data.happiness = min(100, pet_data.happiness + 15)
		EventBus.xp_gained.emit(5, "pet_play")
		_refresh_ui()

func _on_close_button_pressed() -> void:
	hide()
