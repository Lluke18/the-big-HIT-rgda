extends Node

enum step{
	VENTS, #0
	STORAGE, #1
	LAXATIVES, #2
	BATHROOM, #3
	KILL_1, #4
	CAMERAS, #5
	KEYS, #6
	VAMPIRE, #7
	KILL_2, #8
	TONY, #9
	OFFICE, #10
	KILL_3, #11
	GARLIC, #12
	SANDWICH, #13
	PHONE, #14
}

const TOTAL_STEPS = 15

var steps_completed: Array[bool] = []

signal update_page(method_index: step)

func _ready() -> void:
	steps_completed.resize(TOTAL_STEPS)
	reset_steps_progress()

func reset_steps_progress():
	steps_completed.fill(false)
	
func try_to_update_step(method_index: step):
	if steps_completed[method_index] == false:
		steps_completed[method_index] = true
		update_page.emit(method_index)
