extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var acceleration := 50
var friction := 2
var input_direction: Vector2

@export var player_id := 1:
	set(id):
		player_id = id
		#%InputSynchronizer.set_multiplayer_authority(id)

func _ready() -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)


func _physics_process(delta: float) -> void:
	input_direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	var lerp_weight = delta * (acceleration if input_direction else friction)
	velocity = lerp(velocity, input_direction * 500, lerp_weight) 
	move_and_slide()
