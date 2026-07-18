extends Node2D

@onready var pivot_1: Node2D = $Pivot1
@onready var pivot_2: Node2D = $Pivot2

var tween: Tween
var viewport_center: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport_center = get_viewport_rect().size / 2.0
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_position = get_viewport().get_mouse_position()
	look_at(viewport_center)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		if event.pressed:
			pivot_1.rotation_degrees -= 20.0
			pivot_2.rotation_degrees += 20.0
		else:
			pivot_1.rotation_degrees += 20.0
			pivot_2.rotation_degrees -= 20.0
