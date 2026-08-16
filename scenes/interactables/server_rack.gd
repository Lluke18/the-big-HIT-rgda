extends Node3D

@onready var interactable_object: InteractableObject = $InteractableObject

func _ready() -> void:
	interactable_object.interact = Callable(self, "on_servers_broken")
	interactable_object.vampire_interaction_text = "[Left Click] Break servers"
	interactable_object.werewolf_interaction_text = "[Left Click] Break serers"

func on_servers_broken(player: Player):
	if multiplayer.is_server():
		break_server.rpc()
	else:
		# Ask the server to delete the keys
		break_server_for_everyone.rpc_id(1)

@rpc("any_peer", "reliable")
func break_server_for_everyone() -> void:
	if not multiplayer.is_server():
		return
		
	break_server.rpc()
	
@rpc("authority", "call_local", "reliable")
func break_server() -> void:
	NotesManager.try_to_update_step(NotesManager.step.CAMERAS)
	SignalBus.break_cameras.emit()
	interactable_object.remove_from_group("interactable")
