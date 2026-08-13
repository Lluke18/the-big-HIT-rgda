extends Node3D

@onready var animation_player: AnimationPlayer = $GuardModelBase/AnimationPlayer


@export var weapon: Node3D


@export var idle_animation_name: String = "CharacterArmature|Idle"
@export var walk_animation_name: String = "CharacterArmature|Walk"
@export var run_animation_name: String = "CharacterArmature|Run"
@export var interact_animation_name: String = "CharacterArmature|Interact"
@export var jump_animation_name: String = "CharacterArmature|Interact"
@export var death_animation_name: String = "CharacterArmature|Death"
@export var shoot_animation_name: String = "CharacterArmature|Idle_Gun_Shoot"

func _ready() -> void:
	if weapon:
		print(name, "has a weapon!")
		weapon.visible = false

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

func play_death_animation():
	animation_player.play(death_animation_name)

func play_shoot_animation():
	weapon.visible = true
	animation_player.play(shoot_animation_name)
	await animation_player.animation_finished
	weapon.visible = false
