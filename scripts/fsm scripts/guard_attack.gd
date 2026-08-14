extends State

@export var attack_range:Area3D

func Enter():
	print("entered attack!")
	
	npc.velocity = Vector3.ZERO
	npc.animated_character.play_shoot_animation()
	await npc.animated_character.animation_player.animation_finished
	#PLAY SHOOT SOUND HERE!
	
	get_tree().quit()
