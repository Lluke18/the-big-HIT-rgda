extends Player
class_name Werewolf

func _physics_process(delta: float) -> void:
	super(delta)
	
	if not is_multiplayer_authority():
		return
	
	#region Interaction
	seetext.hide()
	if is_instance_valid(see_cast) and see_cast.is_colliding():
		var target = see_cast.get_collider()
		if target != null and target.is_in_group("interactable"): # OR MAKE A GROUP!
			seetext.text = target.werewolf_interaction_text #Singura diferenta e aici
			seetext.show()
			if Input.is_action_just_pressed("interact"):
				target.interact.call(self)
				animated_character.play_interact_animation()
				print("DO STUFF!")
	#endregion
