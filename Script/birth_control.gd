extends Area2D

@export var sheep_scene: PackedScene
@onready var timer: Timer = $Timer
@onready var finish_point_a: Node2D = $FinishPointA
@onready var finish_point_b: Node2D = $FinishPointB

var rng: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	timer.timeout.connect(create_sheep)
	timer.start(rng.randf_range(0.5, 3.0))

func create_sheep():
	var add_sheep = func():
		var sheep: Sheep = sheep_scene.instantiate()
		sheep.global_position = global_position + Vector2.DOWN * 26
		get_tree().get_first_node_in_group("Sheeps").add_child(sheep)
		sheep.on_birth(finish_point_a.global_position, finish_point_b.global_position)
			
	add_sheep.call_deferred()
	timer.start(rng.randf_range(0.5, 3.0))


func _on_area_entered(area):
	area.queue_free.call_deferred()
