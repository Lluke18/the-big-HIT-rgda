extends Node3D
class_name AnimatedCharacter

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var idle_animation_name: String = "CharacterArmature|Idle"
@export var walk_animation_name: String = "CharacterArmature|Walk"
@export var run_animation_name: String = "CharacterArmature|Run"
@export var interact_animation_name: String = "CharacterArmature|Interact"
@export var jump_animation_name: String = "CharacterArmature|Interact"

func play_idle_animation():
	animation_player.play(idle_animation_name)
	
func play_walk_animation():
	animation_player.play(walk_animation_name)
	
func play_run_animation():
	animation_player.play(run_animation_name)
	
func play_interact_animation():
	animation_player.play(interact_animation_name)
	
func play_jump_animation():
	animation_player.play(jump_animation_name)

func play_jump_animation_backwards():
	animation_player.play_backwards(jump_animation_name)
