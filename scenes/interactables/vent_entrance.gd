extends Node3D

@onready var interactable_object: InteractableObject = $InteractableObject
@onready var vent: Node3D = $Vent

@onready var animated_character: AnimatedCharacter = $AnimatedCharacter
@onready var vampire_bat: VampireBat = $VampireBat

@onready var camera_3d: Camera3D = $Camera3D

func _ready() -> void:
	interactable_object.interact = Callable(self, "on_vent_enter")
	
func on_vent_enter(player: Player):
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
	
	camera_3d.clear_current()
	
func on_vent_exit(player: Player):
	player.hide()
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
	
	camera_3d.clear_current()
