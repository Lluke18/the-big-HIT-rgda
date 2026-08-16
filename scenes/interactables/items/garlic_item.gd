extends Node3D

@onready var interactable_object: InteractableObject = $InteractableObject

func _ready() -> void:
	interactable_object.interact = Callable(self, "on_garlic_taken")
	interactable_object.vampire_interaction_text = "[Left Click] Grab garlic"
	interactable_object.werewolf_interaction_text = "[Left Click] Grab garlic"

func on_garlic_taken(player: Player):
	if multiplayer.is_server():
		delete_garlic.rpc()
	else:
		# Ask the server to delete the keys
		delete_garlic_for_everyone.rpc_id(1)

@rpc("any_peer", "reliable")
func delete_garlic_for_everyone() -> void:
	if not multiplayer.is_server():
		return
		
	delete_garlic.rpc()
	
@rpc("authority", "call_local", "reliable")
func delete_garlic() -> void:
	InventoryManager.add_item(InventoryManager.GARLIC)
	NotesManager.try_to_update_step(NotesManager.step.GARLIC)
	queue_free()
