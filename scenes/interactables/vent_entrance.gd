extends Node3D

@export var index: int = 0

@onready var interactable_object: InteractableObject = $InteractableObject
@onready var vent: Node3D = $Vent

@onready var animated_character: AnimatedCharacter = $AnimatedCharacter
@onready var vampire_bat: VampireBat = $VampireBat

@onready var camera_3d: Camera3D = $Camera3D

@onready var spawner_marker: Marker3D = $SpawnerMarker

func _ready() -> void:
	animated_character.visible = false
	vampire_bat.visible = false
	
	interactable_object.interact = Callable(self, "on_vent_enter")
	interactable_object.vampire_interaction_text = "[Left Click] to go inside vent"
	interactable_object.werewolf_interaction_text = "Can't go inside vents!"
	
	SignalBus.switch_to_vent.connect(on_switch_to_vent)
	SignalBus.exit_vent.connect(on_vent_exit)
	
func on_switch_to_vent(vent_index: int):
	if vent_index == index:
		camera_3d.make_current()
	
func on_vent_enter(player: Player):
	if player is Werewolf:
		return
		
	player.hide()
	player.process_mode = Node.PROCESS_MODE_DISABLED
	
	camera_3d.make_current()
	
	animated_character.look_at(vent.global_position)
	animated_character.rotate_y(180.0)
	
	animated_character.visible = true
	vampire_bat.visible = false
	
	animated_character.play_jump_animation()
	await animated_character.animation_player.animation_finished
	
	animated_character.visible = false
	vampire_bat.visible = true
	
	vampire_bat.play_fly_in_animation(vent.global_position)
	await vampire_bat.entered_vent
	
	SignalBus.enter_vent.emit(index)
	
func on_vent_exit(vent_index: int, player: Player):
	if vent_index != index:
		return
		
	player.hide()
	player.global_position = spawner_marker.global_position
	player.process_mode = Node.PROCESS_MODE_DISABLED
	
	camera_3d.make_current()
	
	animated_character.visible = false
	animated_character.look_at(vent.global_position)
	
	vampire_bat.visible = true

	vampire_bat.play_fly_out_animation(vent.global_position)
	await vampire_bat.exited_vent
	
	vampire_bat.visible = false
	animated_character.visible = true
	
	animated_character.play_jump_animation_backwards()
	await animated_character.animation_player.animation_finished
	
	animated_character.visible = false
	
	player.process_mode = Node.PROCESS_MODE_INHERIT
	player.show()
	
	player.camera.make_current()
