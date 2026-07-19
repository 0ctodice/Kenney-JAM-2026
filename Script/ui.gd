extends Control
class_name UI

signal game_over
signal game_started

@onready var points_label: Label = $Points
@onready var points_FX_label: Label = $PointsFX
@onready var timer_label: Label = $Timer
@onready var timer_malus_FX_label: Label = $TimerMalusFX
@onready var timer_bonus_FX_label: Label = $TimerBonusFX

@onready var title_screen: Sprite2D = $TitleScreen
@onready var click_sprite: AnimatedSprite2D = $ClickSprite
@onready var click_label: Label = $Click
@onready var highscore_label: Label = $Highscore

const INIT_TIMER_COUNT = 61

var score: int = 0
var timer: int = INIT_TIMER_COUNT

var buffer: float = 0
var punition: int = int(exp(4)) * 3 / 4

var stop_decounting: bool = false
var game_start: bool = false
var can_click: bool = false

var points_FX_tween: Tween
var timer_malus_FX_tween: Tween
var timer_bonus_FX_tween: Tween
var title_tween: Tween

var title_screen_init_pos: Vector2
var click_sprite_init_pos: Vector2
var click_label_init_pos: Vector2
var highscore_label_init_pos: Vector2

func _ready():
	title_screen_init_pos = title_screen.global_position
	click_sprite_init_pos = click_sprite.global_position
	click_label_init_pos = click_label.global_position
	highscore_label_init_pos = highscore_label.global_position

	game_over.connect(func():
		save_highscore()
		title_screen_fade_in()
	)
	title_screen_fade_in()

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not stop_decounting and game_start:
		buffer += delta
		if buffer > +1.0:
			buffer = 0
			timer -= 1
			timer_label.text = str(timer)
			if timer <= 0:
				game_over.emit()
				stop_decounting = true

func _input(event):
	if can_click and event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		timer = INIT_TIMER_COUNT
		score = 0
		points_label.text = "0"
		if title_tween:
			title_tween.kill()

		title_tween = create_tween()
		title_tween.parallel().tween_property(title_screen, "modulate", Color.TRANSPARENT, 1)
		title_tween.parallel().tween_property(click_sprite, "modulate", Color.TRANSPARENT, 1)
		title_tween.parallel().tween_property(click_label, "modulate", Color.TRANSPARENT, 1)
		title_tween.parallel().tween_property(highscore_label, "modulate", Color.TRANSPARENT, 1)

		can_click = false

		var sheeps: Node2D = get_tree().get_first_node_in_group("Sheeps")
		for sheep in sheeps.get_children():
			sheeps.remove_child(sheep)
			sheep.queue_free()

		title_tween.finished.connect(func():
			game_started.emit()
			game_start = true
			stop_decounting = false
			title_screen.global_position = title_screen_init_pos
			click_sprite.global_position = click_sprite_init_pos
			click_label.global_position = click_label_init_pos
		)

func title_screen_fade_in():
	if title_tween:
		title_tween.kill()

	highscore_label.text = "HIGHSCORE : " + str(get_highscore())

	title_tween = create_tween()
	title_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	title_tween.tween_property(title_screen, "global_position", Vector2(160, 78.5), 1)
	title_tween.parallel().tween_property(click_sprite, "global_position", Vector2(96, 135), 1)
	title_tween.parallel().tween_property(click_label, "global_position", Vector2(107, 125), 1)
	title_tween.parallel().tween_property(title_screen, "modulate", Color.WHITE, 1)
	title_tween.parallel().tween_property(click_sprite, "modulate", Color.WHITE, 1)
	title_tween.parallel().tween_property(click_label, "modulate", Color.WHITE, 1)
	title_tween.chain().tween_property(highscore_label, "modulate", Color.WHITE, 1)

	title_tween.finished.connect(func(): can_click = true)

func add_points(points: int):
	if not stop_decounting:
		var bonus_timer_points = points / 4
		score += points
		timer += bonus_timer_points
		points_label.text = str(score)
		
		# ANIMATING POINTS FX
		points_FX_label.global_position = points_label.global_position
		points_FX_label.modulate = Color.TRANSPARENT
		points_FX_label.text = "+" + str(points)

		if points_FX_tween:
			points_FX_tween.kill()
		points_FX_tween = create_tween()
		points_FX_tween.tween_property(points_FX_label, "modulate", Color.WHITE, 0.25)
		points_FX_tween.parallel().tween_property(points_FX_label, "global_position", points_FX_label.global_position + Vector2.UP * 20, 0.25)
		points_FX_tween.chain().tween_property(points_FX_label, "global_position", points_FX_label.global_position + Vector2.UP * 100, 1)
		points_FX_tween.parallel().tween_property(points_FX_label, "modulate", Color.TRANSPARENT, 1)

		# ANIMATING TIMER FX
		timer_bonus_FX_label.global_position = timer_label.global_position
		timer_bonus_FX_label.modulate = Color.TRANSPARENT
		timer_bonus_FX_label.text = "+" + str(bonus_timer_points)

		if timer_bonus_FX_tween:
			timer_bonus_FX_tween.kill()
		timer_bonus_FX_tween = create_tween()
		timer_bonus_FX_tween.tween_property(timer_bonus_FX_label, "modulate", Color.WHITE, 0.25)
		timer_bonus_FX_tween.parallel().tween_property(timer_bonus_FX_label, "global_position", timer_bonus_FX_label.global_position + Vector2.UP * 20, 0.25)
		timer_bonus_FX_tween.chain().tween_property(timer_bonus_FX_label, "global_position", timer_bonus_FX_label.global_position + Vector2.UP * 100, 1)
		timer_bonus_FX_tween.parallel().tween_property(timer_bonus_FX_label, "modulate", Color.TRANSPARENT, 1)


func remove_time():
	if stop_decounting:
		return
	if timer <= punition:
		timer = 0
		timer_label.text = str(timer)
		game_over.emit()
		stop_decounting = true
	else:
		timer -= punition

	if not stop_decounting:
		timer_malus_FX_label.global_position = timer_label.global_position
		timer_malus_FX_label.modulate = Color.TRANSPARENT
		timer_malus_FX_label.text = "-" + str(punition)

		if timer_malus_FX_tween:
			timer_malus_FX_tween.kill()
		timer_malus_FX_tween = create_tween()
		timer_malus_FX_tween.tween_property(timer_malus_FX_label, "modulate", Color.WHITE, 0.25)
		timer_malus_FX_tween.parallel().tween_property(timer_malus_FX_label, "global_position", timer_malus_FX_label.global_position + Vector2.UP * 20, 0.25)
		timer_malus_FX_tween.chain().tween_property(timer_malus_FX_label, "global_position", timer_malus_FX_label.global_position + Vector2.UP * 100, 1)
		timer_malus_FX_tween.parallel().tween_property(timer_malus_FX_label, "modulate", Color.TRANSPARENT, 1)

func get_highscore():
	var highscore: int = 0
	if FileAccess.file_exists("user://savegame.save"):
		var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
		while save_file.get_position() < save_file.get_length():
			var json_string = save_file.get_line()
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
				continue

			# Get the data from the JSON object.
			var node_data = json.data
			highscore = node_data["highscore"]
	return highscore
				
func save_highscore():
	if get_highscore() < score:
		var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
		var node_data = {"highscore": score}
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)
