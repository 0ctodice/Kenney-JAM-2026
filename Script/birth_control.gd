extends Area2D

@export var sheep_scene: PackedScene

var rng: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_entered(area: Area2D):
	area.queue_free.call_deferred()
	var add_sheep = func():
		for i in range(2):
			var sheep: Sheep = sheep_scene.instantiate()
			sheep.global_position = global_position + Vector2.DOWN * 26
			get_parent().add_child(sheep)
			sheep.on_birth()
	add_sheep.call_deferred()
