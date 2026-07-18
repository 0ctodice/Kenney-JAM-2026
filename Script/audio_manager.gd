extends Node2D
class_name AudioManager

@onready var beeeh_normal: AudioStreamPlayer = $BeeehNormal
@onready var beeeh_bizarre: AudioStreamPlayer = $BeeehBizarre
@onready var shearing: AudioStreamPlayer = $Shearing
@onready var pop: AudioStreamPlayer = $Pop

var rng: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()

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