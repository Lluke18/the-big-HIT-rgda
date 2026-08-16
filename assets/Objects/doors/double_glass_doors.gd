extends Node3D

@export var is_interactable: bool = false

@onready var interactable_object: InteractableObject = $InteractableObject
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if not is_interactable:
		interactable_object.remove_from_group("interactable")
		animation_player.play("OpenDoor")
	else:
		animation_player.play_backwards("OpenDoor")
	
	interactable_object.interact = Callable(self, "unlock_door")
	interactable_object.vampire_interaction_text = "[Left Click] Unlock door (requires keys)"
	interactable_object.werewolf_interaction_text = "[Left Click] Unlock door (requires keys)"

func unlock_door(player: Player):
	if multiplayer.is_server():
		open_door.rpc()
	else:
		# Ask the server to delete the keys
		setup_doors_for_everyone.rpc_id(1)

@rpc("any_peer", "reliable")
func setup_doors_for_everyone() -> void:
	if not multiplayer.is_server():
		return
		
	open_door.rpc()
	
@rpc("authority", "call_local", "reliable")
func open_door() -> void:
	if InventoryManager.obtained_items.has(InventoryManager.BOSS_KEYS):
		animation_player.play("OpenDoor")
		interactable_object.remove_from_group("interactable")

@rpc("authority", "call_local", "reliable")
func npc_opens_door() -> void:
	animation_player.play("OpenDoor")
