extends ProgressBar
class_name GarlicMeter

var is_increasing: bool = false
@export var increase_rate: float = 1

func _ready() -> void:
	hide()
	is_increasing = false
	value = min_value

func _process(delta: float) -> void:
	if not is_increasing:
		value -= increase_rate
		if value == min_value:
			hide()
	else:
		value += increase_rate 
		if value == max_value:
			SignalBus.game_lost.emit("Vampire got too close to garlic and died. Retired!")
			hide()

func start_increase():
	show()
	is_increasing = true
	
func stop_increase():
	is_increasing = false
