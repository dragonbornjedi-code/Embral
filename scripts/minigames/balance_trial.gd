extends Node2D
## BalanceTrial — Hit the moving bar in the green zone. 5 rounds.

var round_count: int = 0
var score: int = 0
var bar_position: float = 0.0
var bar_speed: float = 200.0
var bar_direction: float = 1.0
var active: bool = false
var round_active: bool = false
var bar_rect: ColorRect
var zone_rect: ColorRect
var round_label: Label
var score_label: Label
var instruction_label: Label
var feedback_label: Label
const SCREEN_WIDTH: float = 400.0
const BAR_WIDTH: float = 20.0
const ZONE_X: float = 170.0
const ZONE_WIDTH: float = 60.0

func _ready() -> void:
	_setup_ui()
	_start_round()

func _setup_ui() -> void:
	var title = Label.new()
	title.text = "Balance Trial!"
	title.position = Vector2(130, 10)
	title.add_theme_font_size_override("font_size", 24)
	add_child(title)
	round_label = Label.new()
	round_label.position = Vector2(10, 10)
	add_child(round_label)
	score_label = Label.new()
	score_label.position = Vector2(320, 10)
	add_child(score_label)
	instruction_label = Label.new()
	instruction_label.text = "Press SPACE or tap when bar is in green zone!"
	instruction_label.position = Vector2(30, 50)
	add_child(instruction_label)
	var track = ColorRect.new()
	track.color = Color(0.3, 0.3, 0.3)
	track.size = Vector2(SCREEN_WIDTH, 30)
	track.position = Vector2(0, 150)
	add_child(track)
	zone_rect = ColorRect.new()
	zone_rect.color = Color(0.2, 0.8, 0.2)
	zone_rect.size = Vector2(ZONE_WIDTH, 30)
	zone_rect.position = Vector2(ZONE_X, 150)
	add_child(zone_rect)
	bar_rect = ColorRect.new()
	bar_rect.color = Color(0.9, 0.2, 0.2)
	bar_rect.size = Vector2(BAR_WIDTH, 30)
	bar_rect.position = Vector2(0, 150)
	add_child(bar_rect)
	feedback_label = Label.new()
	feedback_label.position = Vector2(150, 200)
	feedback_label.add_theme_font_size_override("font_size", 24)
	add_child(feedback_label)
	var tap_btn = Button.new()
	tap_btn.text = "TAP!"
	tap_btn.custom_minimum_size = Vector2(120, 60)
	tap_btn.position = Vector2(140, 260)
	tap_btn.add_theme_font_size_override("font_size", 24)
	tap_btn.pressed.connect(_on_tap)
	add_child(tap_btn)
	var back = Button.new()
	back.text = "Back"
	back.position = Vector2(10, 360)
	back.pressed.connect(_go_back)
	add_child(back)

func _start_round() -> void:
	if round_count >= 5:
		_end_game()
		return
	round_count += 1
	round_label.text = "Round %d/5" % round_count
	score_label.text = "Score: %d" % score
	feedback_label.text = "Get ready!"
	bar_position = 0.0
	bar_speed = 150.0 + (round_count - 1) * 30.0
	active = true
	round_active = true
	await get_tree().create_timer(0.5).timeout
	feedback_label.text = ""

func _process(delta: float) -> void:
	if not active or not round_active: return
	bar_position += bar_speed * bar_direction * delta
	if bar_position >= SCREEN_WIDTH - BAR_WIDTH:
		bar_direction = -1.0
	elif bar_position <= 0:
		bar_direction = 1.0
	bar_rect.position.x = bar_position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_on_tap()

func _on_tap() -> void:
	if not round_active: return
	round_active = false
	active = false
	var bar_center = bar_position + BAR_WIDTH / 2.0
	var zone_center = ZONE_X + ZONE_WIDTH / 2.0
	if abs(bar_center - zone_center) <= ZONE_WIDTH / 2.0:
		score += 1
		feedback_label.text = "Perfect! 🌟"
	else:
		feedback_label.text = "So close! Try again! 💪"
	await get_tree().create_timer(1.2).timeout
	_start_round()

func _end_game() -> void:
	active = false
	feedback_label.text = "Done! Score: %d/5 🎉" % score
	EventBus.xp_gained.emit(score * 2, "balance_trial")

func _go_back() -> void:
	TransitionManager.change_scene("res://scenes/overworld/hearthveil/hearthveil.tscn")
