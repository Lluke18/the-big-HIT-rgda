extends Node3D

@onready var interactable_object: InteractableObject = $InteractableObject
@onready var camera_3d: Camera3D = $Camera3D

func _ready() -> void:
	interactable_object.interact = Callable(self, "on_locker_enter")
	interactable_object.vampire_interaction_text = "[Left Click] Wait for your target in the locker"
	interactable_object.werewolf_interaction_text = "[Left Click] Wait for your target in the locker"
	
	SignalBus.exit_locker.connect(on_locker_exit)

func on_locker_enter(player: Player):
	player.hide_crosshair()
		
	player.hide()
	player.process_mode = Node.PROCESS_MODE_DISABLED
	
	camera_3d.make_current()
	
	player.locker_ui.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func on_locker_exit(player: Player):
	print("Player should exit")
	player.show_crosshair()
		
	player.show()
	player.process_mode = Node.PROCESS_MODE_INHERIT
	
	player.camera.make_current()
	
	player.locker_ui.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
