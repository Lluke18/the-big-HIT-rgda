extends Node3D

@onready var interactable_object: InteractableObject = $InteractableObject

func _ready() -> void:
	interactable_object.interact = Callable(self, "on_vent_entered")
	
func on_vent_entered():
	print("Vent entered")
