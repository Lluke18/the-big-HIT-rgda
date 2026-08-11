extends Player

func play_enter_vent_animation():
	animated_character.play_jump_animation()
	await animated_character.animation_player.animation_finished
	
	animated_character.visible = false
	
	
