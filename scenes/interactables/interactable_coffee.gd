extends Node3D

@onready var interactable_object: InteractableObject = $InteractableObject

func _ready() -> void:
	interactable_object.interact = Callable(self, "on_laxatives_put")
	interactable_object.vampire_interaction_text = "[Left Click] Put Laxatives (need Laxatives)"
	interactable_object.werewolf_interaction_text = "[Left Click] Put Laxatives (need Laxatives)"

func on_laxative_put(player: Player):
	if multiplayer.is_server():
		put_laxatives.rpc()
	else:
		# Ask the server to delete the keys
		put_laxatives_for_everyone.rpc_id(1)

@rpc("any_peer", "reliable")
func put_laxatives_for_everyone() -> void:
	if not multiplayer.is_server():
		return
		
	put_laxatives.rpc()
	
@rpc("authority", "call_local", "reliable")
func put_laxatives() -> void:
	if InventoryManager.obtained_items.has(InventoryManager.LAXATIVES):
		NotesManager.try_to_update_step(NotesManager.step.BATHROOM)
		SignalBus.laxatives_put.emit()
		interactable_object.remove_from_group("interactable")
