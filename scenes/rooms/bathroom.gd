extends Node3D

@onready var stall_5_middle: BathroomStall = $"Stalls/Stall5(Middle)"

func _ready() -> void:
	stall_5_middle.open_door()

func close_middle_door():
	stall_5_middle.close_door()
