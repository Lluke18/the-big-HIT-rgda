extends NPC
class_name Guard

var bullet = preload("res://scenes/NPCs/misc/bullet.tscn")
var bullet_instance 

func _ready() -> void:
	super()
	SignalBus.found_intruder.connect(on_found_intruder)


func on_found_intruder():
	fsm.force_change_state("Attack")
#or just quit here
