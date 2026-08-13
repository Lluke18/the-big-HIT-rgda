extends Node3D

@onready var interactable_object: InteractableObject = $InteractableObject

func _ready() -> void:
	interactable_object.interact = Callable(self, "on_keys_taken")
	interactable_object.vampire_interaction_text = "[Left Click] Grab keys"
	interactable_object.werewolf_interaction_text = "[Left Click] Grab keys"

func on_keys_taken(player: Player):
	if multiplayer.is_server():
		delete_keys.rpc()
	else:
		# Ask the server to delete the keys
		delete_keys_for_everyone.rpc_id(1)

@rpc("any_peer", "reliable")
func delete_keys_for_everyone() -> void:
	if not multiplayer.is_server():
		return
		
	delete_keys.rpc()
	
@rpc("authority", "call_local", "reliable")
func delete_keys() -> void:
	InventoryManager.add_item(InventoryManager.BOSS_KEYS)
	queue_free()
