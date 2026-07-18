extends Control
class_name UI

signal game_over

@onready var points_label: Label = $Points
@onready var timer_label: Label = $Timer
var total: int = 0
var timer: int = 60

var buffer: float = 0
var punition: int = int(exp(4)) / 2

var stop_decounting: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not stop_decounting:
		buffer += delta
		if buffer > +1.0:
			buffer = 0
			timer -= 1
			timer_label.text = "TIME : " + str(timer)
			if timer <= 0:
				game_over.emit()
				stop_decounting = true

func add_points(points: int):
	total += points
	timer += points / 2
	points_label.text = "WOOL POINTS : " + str(total)

func remove_time():
	if timer <= punition:
		timer = 0
		timer_label.text = "TIME : " + str(timer)
		game_over.emit()
		stop_decounting = true
	else:
		timer -= punition