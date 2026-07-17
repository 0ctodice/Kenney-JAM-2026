extends Area2D

@onready var wool: Node2D = $Wool
@onready var wool_sprite: Sprite2D = $Wool/WoolSprite

@onready var feet_01: Node2D = $Feet01
@onready var feet_02: Node2D = $Feet02
@onready var head: Node2D = $Head

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var mouse_on: bool = false
var can_shear: bool = true
var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Agrandir Wool
	wool.scale += Vector2.ONE * delta / 5.0
	#Agrandir la collision shape
	collision_shape.scale += Vector2.ONE * delta / 5.0
	collision_shape.global_position = wool_sprite.global_position

func _input(event):
	if mouse_on and can_shear and event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		print("BEEEEEH")
		can_shear = false

func _on_mouse_entered():
	mouse_on = true

func _on_mouse_exited():
	mouse_on = false
