extends ProgressBar
class_name SuspicionBar

var is_increasing: bool = false
@export var increase_rate: float = 0.1

func _ready() -> void:
	is_increasing = false
	value = min_value

func _process(delta: float) -> void:
	if not is_increasing:
		value -= increase_rate
	else:
		value += increase_rate

func start_increase():
	is_increasing = true
	
func stop_increase():
	is_increasing = false
	
