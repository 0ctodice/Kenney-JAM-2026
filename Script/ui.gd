extends Control
class_name UI

signal game_over

@onready var points_label: Label = $Points
@onready var points_FX_label: Label = $PointsFX
@onready var timer_label: Label = $Timer
@onready var timer_malus_FX_label: Label = $TimerMalusFX
@onready var timer_bonus_FX_label: Label = $TimerBonusFX

var total: int = 0
var timer: int = 60

var buffer: float = 0
var punition: int = int(exp(4))

var stop_decounting: bool = false

var points_FX_tween: Tween
var timer_malus_FX_tween: Tween
var timer_bonus_FX_tween: Tween

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not stop_decounting:
		buffer += delta
		if buffer > +1.0:
			buffer = 0
			timer -= 1
			timer_label.text = str(timer)
			if timer <= 0:
				game_over.emit()
				stop_decounting = true

func add_points(points: int):
	if not stop_decounting:
		total += points
		timer += points / 4
		points_label.text = str(total)
		
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
		timer_bonus_FX_label.text = "+" + str(points / 4)

		if timer_bonus_FX_tween:
			timer_bonus_FX_tween.kill()
		timer_bonus_FX_tween = create_tween()
		timer_bonus_FX_tween.tween_property(timer_bonus_FX_label, "modulate", Color.WHITE, 0.25)
		timer_bonus_FX_tween.parallel().tween_property(timer_bonus_FX_label, "global_position", timer_bonus_FX_label.global_position + Vector2.UP * 20, 0.25)
		timer_bonus_FX_tween.chain().tween_property(timer_bonus_FX_label, "global_position", timer_bonus_FX_label.global_position + Vector2.UP * 100, 1)
		timer_bonus_FX_tween.parallel().tween_property(timer_bonus_FX_label, "modulate", Color.TRANSPARENT, 1)


func remove_time():
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