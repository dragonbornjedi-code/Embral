extends Node2D
## EmotionSort — Sort emotions into two buckets. No wrong answers.

const EMOTIONS = ["Happy", "Sad", "Angry", "Worried", "Excited", "Calm"]
const FEELS_GOOD = ["Happy", "Excited", "Calm"]
var sorted_count: int = 0
var selected_emotion: String = ""
var selected_btn: Button = null
var feedback_label: Label
var progress_label: Label
var instruction_label: Label

func _ready() -> void:
	_setup_ui()

func _setup_ui() -> void:
	var title = Label.new()
	title.text = "Emotion Sort!"
	title.position = Vector2(130, 10)
	title.add_theme_font_size_override("font_size", 24)
	add_child(title)
	instruction_label = Label.new()
	instruction_label.text = "Pick a feeling, then choose a bucket!"
	instruction_label.position = Vector2(60, 45)
	add_child(instruction_label)
	progress_label = Label.new()
	progress_label.position = Vector2(10, 10)
	add_child(progress_label)
	feedback_label = Label.new()
	feedback_label.position = Vector2(120, 310)
	feedback_label.add_theme_font_size_override("font_size", 20)
	add_child(feedback_label)
	for i in range(EMOTIONS.size()):
		var btn = Button.new()
		btn.text = EMOTIONS[i]
		btn.custom_minimum_size = Vector2(100, 45)
		btn.position = Vector2(10 + (i % 3) * 130, 80 + (i / 3) * 55)
		btn.pressed.connect(_on_emotion_pressed.bind(EMOTIONS[i], btn))
		add_child(btn)
	var good_bucket = Button.new()
	good_bucket.text = "😊 Feels Good"
	good_bucket.custom_minimum_size = Vector2(150, 50)
	good_bucket.position = Vector2(20, 240)
	good_bucket.pressed.connect(_on_bucket_pressed.bind("good"))
	add_child(good_bucket)
	var hard_bucket = Button.new()
	hard_bucket.text = "😟 Feels Hard"
	hard_bucket.custom_minimum_size = Vector2(150, 50)
	hard_bucket.position = Vector2(220, 240)
	hard_bucket.pressed.connect(_on_bucket_pressed.bind("hard"))
	add_child(hard_bucket)
	var back = Button.new()
	back.text = "Back"
	back.position = Vector2(10, 360)
	back.pressed.connect(_go_back)
	add_child(back)
	progress_label.text = "Sorted: 0/%d" % EMOTIONS.size()

func _on_emotion_pressed(emotion: String, btn: Button) -> void:
	selected_emotion = emotion
	selected_btn = btn
	feedback_label.text = "Now pick a bucket for: %s" % emotion

func _on_bucket_pressed(bucket: String) -> void:
	if selected_emotion == "":
		feedback_label.text = "Pick a feeling first!"
		return
	var response = ""
	if bucket == "good" and selected_emotion in FEELS_GOOD:
		response = "Great thinking! %s does feel good! 🌟" % selected_emotion
	elif bucket == "hard" and not selected_emotion in FEELS_GOOD:
		response = "You're right! %s can feel hard. 💪" % selected_emotion
	else:
		response = "Good thinking! All feelings are valid! 💛"
	feedback_label.text = response
	if is_instance_valid(selected_btn):
		selected_btn.disabled = true
	selected_emotion = ""
	selected_btn = null
	sorted_count += 1
	progress_label.text = "Sorted: %d/%d" % [sorted_count, EMOTIONS.size()]
	if sorted_count >= EMOTIONS.size():
		await get_tree().create_timer(1.0).timeout
		_complete()

func _complete() -> void:
	feedback_label.text = "Amazing! You know your feelings! 🎉"
	EventBus.xp_gained.emit(15, "emotion_sort")

func _go_back() -> void:
	TransitionManager.change_scene("res://scenes/overworld/hearthveil/hearthveil.tscn")
