extends Node3D

@onready var interactable_object: InteractableObject = $InteractableObject

func _ready() -> void:
	interactable_object.interact = Callable(self, "on_laxatives_taken")
	interactable_object.vampire_interaction_text = "[Left Click] Grab keys"
	interactable_object.werewolf_interaction_text = "[Left Click] Grab keys"

func on_laxatives_taken(player: Player):
	if multiplayer.is_server():
		delete_laxatives.rpc()
	else:
		# Ask the server to delete the keys
		delete_laxatives_for_everyone.rpc_id(1)

@rpc("any_peer", "reliable")
func delete_laxatives_for_everyone() -> void:
	if not multiplayer.is_server():
		return
		
	delete_laxatives.rpc()
	
@rpc("authority", "call_local", "reliable")
func delete_laxatives() -> void:
	InventoryManager.add_item(InventoryManager.LAXATIVES)
	NotesManager.try_to_update_step(NotesManager.step.LAXATIVES)
	queue_free()
