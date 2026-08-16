extends NPC
class_name Guard

var bullet = preload("res://scenes/NPCs/misc/bullet.tscn")
var bullet_instance 
signal play_alarm

@export var timer: Timer



func _ready() -> void:
	super()
	SignalBus.found_intruder.connect(on_found_intruder)
	

func on_found_intruder():
	if not fsm.current_state.name == "ChasePlayer":
		fsm.change_state(fsm.current_state, "ChasePlayer")
