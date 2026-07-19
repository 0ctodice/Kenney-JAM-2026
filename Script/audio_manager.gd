extends Node2D
class_name AudioManager

@onready var beeeh_normal: AudioStreamPlayer = $BeeehNormal
@onready var beeeh_bizarre: AudioStreamPlayer = $BeeehBizarre
@onready var shearing: AudioStreamPlayer = $Shearing
@onready var pop: AudioStreamPlayer = $Pop
@onready var step: AudioStreamPlayer = $Step
@onready var game_over: AudioStreamPlayer = $GameOver
@onready var music: AudioStreamPlayer = $Music

var rng: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	var ui: UI = get_tree().get_first_node_in_group("UI")
	ui.game_over.connect(play_game_over)
	ui.game_started.connect(play_music)
	play_music()

func play_random_beeeh_normal():
	beeeh_normal.pitch_scale = rng.randf_range(0.8, 1.2)
	beeeh_normal.play()

func play_random_beeeh_bizarre():
	beeeh_bizarre.pitch_scale = rng.randf_range(0.8, 1.2)
	beeeh_bizarre.play()

func play_shearing():
	shearing.pitch_scale = rng.randf_range(0.8, 1.2)
	shearing.play()

func play_pop():
	pop.pitch_scale = rng.randf_range(0.8, 1.2)
	pop.play()

func play_step():
	print("playing")
	step.pitch_scale = rng.randf_range(0.8, 1.2)
	step.play()

func play_game_over():
	music.stop()
	game_over.play()

func play_music():
	if not music.playing:
		game_over.stop()
		music.play()
