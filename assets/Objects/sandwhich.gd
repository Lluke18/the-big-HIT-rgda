extends Node3D

@onready var interactable_object: InteractableObject = $InteractableObject

func _ready() -> void:
	interactable_object.interact = Callable(self, "on_garlic_put")
	interactable_object.vampire_interaction_text = "[Left Click] Put garlic in sandwhich"
	interactable_object.werewolf_interaction_text = "[Left Click] Put garlic in sandwhich"

func on_garlic_put(player: Player):
	if multiplayer.is_server():
		put_garlic.rpc()
	else:
		# Ask the server to delete the keys
		put_garlic_for_everyone.rpc_id(1)

@rpc("any_peer", "reliable")
func put_garlic_for_everyone() -> void:
	if not multiplayer.is_server():
		return
		
	put_garlic.rpc()
	
@rpc("authority", "call_local", "reliable")
func put_garlic() -> void:
	if InventoryManager.obtained_items.has(InventoryManager.GARLIC):
		NotesManager.try_to_update_step(NotesManager.step.SANDWICH)
		interactable_object.remove_from_group("interactable")
