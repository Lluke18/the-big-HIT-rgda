extends Node3D

@onready var stall_6_middle: BathroomStall = $"Stalls/Stall6(Middle)"

func _ready() -> void:
	stall_6_middle.open_door()

func close_middle_door():
	stall_6_middle.close_door()
