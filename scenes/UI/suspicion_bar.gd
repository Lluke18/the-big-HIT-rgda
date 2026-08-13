extends ProgressBar
class_name SuspicionBar

var is_increasing: bool = false
@export var increase_rate: float = 0.1
signal detected_player


func _ready() -> void:
	is_increasing = false
	value = min_value

func _process(delta: float) -> void:
	if not is_increasing:
		value -= increase_rate
	else:
		value += increase_rate
		if value == max_value:
			print("DETECTED INTRUDER!")
			detected_player.emit()
			#await get_tree().create_timer(0.2).timeout
			#freeze or maybe delete the bar
			self.process_mode = Node.PROCESS_MODE_DISABLED

func start_increase():
	is_increasing = true
	
func stop_increase():
	is_increasing = false
