extends Node3D
class_name BathroomStall

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func open_door():
	animation_player.play("OpenDoor")
	
func close_door():
	animation_player.play_backwards("OpenDoor")
