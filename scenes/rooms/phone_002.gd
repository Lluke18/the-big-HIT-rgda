extends MeshInstance3D

@onready var interactable_object: InteractableObject = $InteractableObject

func _ready() -> void:
	interactable_object.interact = Callable(self, "on_call_tony")
	interactable_object.vampire_interaction_text = "[Left Click] Call Tony"
	interactable_object.werewolf_interaction_text = "[Left Click] Call Tony"

func on_call_tony(player: Player):
	if multiplayer.is_server():
		call_tony.rpc()
	else:
		# Ask the server to delete the keys
		call_tony_for_everyone.rpc_id(1)

@rpc("any_peer", "reliable")
func call_tony_for_everyone() -> void:
	if not multiplayer.is_server():
		return
		
	call_tony.rpc()
	
@rpc("authority", "call_local", "reliable")
func call_tony() -> void:
	SignalBus.call_tony.emit()
	NotesManager.try_to_update_step(NotesManager.step.PHONE)
