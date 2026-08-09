extends Node
class_name State

@export var npc: NPC

signal state_transition(source_state : State, new_state_name : String)

func Enter():
	pass
	
func Exit():
	pass
	
func Update(_delta:float):
	pass

func Physics_Update(_delta: float):
	pass
