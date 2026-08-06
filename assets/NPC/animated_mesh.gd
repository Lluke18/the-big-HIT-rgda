extends Node3D
class_name AnimatedMesh

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_idle_animation():
	animation_player.play("CharacterArmature|Idle")
	
func play_walk_animation():
	animation_player.play("CharacterArmature|Walk")
	
func play_run_animation():
	animation_player.play("CharacterArmature|Run")
