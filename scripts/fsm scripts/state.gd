extends Node
class_name State

@export var npc: NPC

@warning_ignore("unused_signal")
signal state_transition

func Enter():
	pass
	
func Exit():
	pass
	
func Update(_delta:float):
	pass

func Physics_Update(_delta: float):
	pass
