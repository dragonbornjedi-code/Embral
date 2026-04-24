extends CanvasLayer
## SettingsMenu — Global configuration for audio, display, and hardware.
## Persists to user://config.json via ConfigLoader.

@onready var sfx_slider = %SFXSlider
@onready var music_slider = %MusicSlider
@onready var fullscreen_check = %FullscreenCheck
@onready var ps5_check = %PS5Check
@onready var wii_check = %WiiCheck
@onready var ha_check = %HACheck
@onready var frequency_dropdown = %FrequencyDropdown
@onready var pin_button = %SetPINButton

func _ready() -> void:
	# Initial hide
	$Control.hide()
	_load_settings()


func open() -> void:
	_load_settings()
	$Control.show()


func close() -> void:
	$Control.hide()


func _load_settings() -> void:
	# SFX
	sfx_slider.value = ConfigLoader.get_value("sfx_volume", 0.8)
	# Music
	music_slider.value = ConfigLoader.get_value("music_volume", 0.8)
	# Fullscreen
	fullscreen_check.button_pressed = ConfigLoader.get_value("fullscreen", false)
	# Hardware overrides (default from HardwareManager if not set)
	ps5_check.button_pressed = ConfigLoader.get_value("override_ps5", HardwareManager.has_ps5())
	wii_check.button_pressed = ConfigLoader.get_value("override_wii", HardwareManager.has_wii())
	ha_check.button_pressed = ConfigLoader.get_value("override_ha", HardwareManager.has_ha())
	# Check-in frequency
	var freq = ConfigLoader.get_value("checkin_frequency", 1800) # Default 30 min
	match freq:
		900: frequency_dropdown.selected = 0
		1800: frequency_dropdown.selected = 1
		3600: frequency_dropdown.selected = 2
		-1: frequency_dropdown.selected = 3
		_: frequency_dropdown.selected = 1


func _on_sfx_slider_value_changed(value: float) -> void:
	ConfigLoader.set_value("sfx_volume", value)


func _on_music_slider_value_changed(value: float) -> void:
	ConfigLoader.set_value("music_volume", value)


func _on_fullscreen_check_toggled(button_pressed: bool) -> void:
	ConfigLoader.set_value("fullscreen", button_pressed)
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_ps5_check_toggled(button_pressed: bool) -> void:
	ConfigLoader.set_value("override_ps5", button_pressed)


func _on_wii_check_toggled(button_pressed: bool) -> void:
	ConfigLoader.set_value("override_wii", button_pressed)


func _on_ha_check_toggled(button_pressed: bool) -> void:
	ConfigLoader.set_value("override_ha", button_pressed)


func _on_frequency_dropdown_item_selected(index: int) -> void:
	var freq = 1800
	match index:
		0: freq = 900
		1: freq = 1800
		2: freq = 3600
		3: freq = -1
	ConfigLoader.set_value("checkin_frequency", freq)


func _on_set_pin_button_pressed() -> void:
	# For white-box: simple placeholder for PIN input
	# In real implementation, this would open a sub-popup
	print("[Settings] Parent PIN entry requested.")


func _on_close_button_pressed() -> void:
	close()
