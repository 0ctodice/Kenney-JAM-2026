extends Area2D

@onready var wool: Node2D = $Wool
@onready var wool_sprite: Sprite2D = $Wool/WoolSprite

@onready var feet_01: Node2D = $Feet01
@onready var feet_02: Node2D = $Feet02
@onready var head: Node2D = $Head
@onready var head_sprite: Sprite2D = $Head/Sprite2D

@onready var particles: CPUParticles2D = $Particles
@onready var walk_timer: Timer = $WalkTimer

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var mouse_on: bool = false
var can_shear: bool = true
var can_walk: bool = true
var speed_factor: float = 1.0
var elastic_limit: float = 3.0
var plastic_limit: float = 4.0

var timing_head_idle: float = 0.0

var tween: Tween
var rng: RandomNumberGenerator

var finish_point_a: Vector2
var finish_point_b: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	speed_factor = rng.randf_range(2.0, 5.0)
	set_random_target()
	walk_timer.timeout.connect(func(): can_walk = true)

	finish_point_a = $"/root/World/FinishPointA".global_position
	finish_point_b = $"/root/World/FinishPointB".global_position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_shear:
		var scaling: float = delta / speed_factor
		wool.scale += Vector2.ONE * scaling
		collision_shape.scale += Vector2.ONE * scaling
		collision_shape.global_position = wool_sprite.global_position

	if wool.scale.x >= plastic_limit and can_shear:
		clear_wool()
		wool.visible = false
		feet_01.visible = false
		feet_02.visible = false
		head.visible = false
		collision_shape.visible = false
		particles.finished.connect(queue_free.call_deferred)
		particles.emitting = true
	elif wool.scale.x >= elastic_limit and can_shear:
		wool.position = lerp(wool.position, Vector2(rng.randf_range(-1, 1), 0) * wool.scale.x, 0.1)
	else:
		timing_head_idle += delta
		if timing_head_idle >= 0.5:
			timing_head_idle = 0.0
			if head_sprite.position.y == 0:
				head_sprite.position.y = 1
			else:
				head_sprite.position.y = 0
	
		if can_shear:
			if !nav_agent.is_target_reachable() or nav_agent.is_target_reached():
				set_random_target()
				can_walk = false
				walk_timer.start(rng.randf_range(0.5, 2.0))
		else:
			if nav_agent.is_target_reached():
				if nav_agent.target_position == finish_point_a:
					nav_agent.target_position = finish_point_b
				elif nav_agent.target_position == finish_point_b:
					print("THE SHEEP IS FUCKING")
					
		if !nav_agent.is_target_reached() and can_walk:
			global_position = lerp(global_position, nav_agent.get_next_path_position(), 0.002 if can_shear else 0.005)

func _input(event):
	if mouse_on and can_shear and event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		clear_wool()

func clear_wool():
	can_shear = false
	particles.amount = int(wool.scale.x * 10)
	particles.emitting = true
	wool.scale = Vector2.ONE
	collision_shape.scale = Vector2.ONE
	collision_shape.global_position = wool_sprite.global_position
	wool_sprite.region_rect = Rect2(16, 0, 16, 16)
	nav_agent.target_position = finish_point_a
	can_walk = false
	walk_timer.start(rng.randf_range(0.5, 2.0))

func set_random_target():
	nav_agent.target_position = global_position + Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)) * 50.0

func _on_mouse_entered():
	mouse_on = true

func _on_mouse_exited():
	mouse_on = false
