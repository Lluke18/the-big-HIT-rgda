extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var acceleration := 50
var friction := 2


func _physics_process(delta: float) -> void:
	var input = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	var lerp_weight = delta * (acceleration if input else friction)
	velocity = lerp(velocity, input * 500, lerp_weight) 
	move_and_slide()
