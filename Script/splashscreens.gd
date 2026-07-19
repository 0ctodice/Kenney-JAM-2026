extends Node2D

@onready var octodice: Sprite2D = $OctoDice
@onready var jam: Sprite2D = $JAM

var tween: Tween
var splash_speed: float = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(octodice, "modulate", Color.WHITE, splash_speed / 2)
	tween.parallel().tween_property(octodice, "scale", Vector2.ONE * 0.2, splash_speed)
	tween.chain().tween_property(octodice, "modulate", Color.TRANSPARENT, splash_speed)
	tween.parallel().tween_property(octodice, "scale", Vector2.ONE * 0.25, splash_speed)
	tween.chain()
	tween.tween_property(jam, "modulate", Color.WHITE, splash_speed / 2)
	tween.parallel().tween_property(jam, "scale", Vector2.ONE * 0.45, splash_speed)
	tween.chain().tween_property(jam, "modulate", Color.TRANSPARENT, splash_speed)
	tween.parallel().tween_property(jam, "scale", Vector2.ONE * 0.5, splash_speed)

	tween.finished.connect(func(): get_tree().change_scene_to_file("res://Scene/world.tscn"))

func _input(event):
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		if not event.pressed:
			get_tree().change_scene_to_file("res://Scene/world.tscn")
