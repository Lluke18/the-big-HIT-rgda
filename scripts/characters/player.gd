extends CharacterBody3D

class_name Player

const SPRINT_SPEED = 8.7  #RUUUUN
var walk_speed := 5.0
var current_speed
var jump_velocity := 4.5
const SENSITIVITY = 0.003

var gravity = 9.8
@export var camera : Camera3D
@export var canvas_layer : CanvasLayer
@export var head : Node3D

#headbob vars
@export var bob_freq : float = 2.4
@export var bob_amp : float = 0.03
var t_bob : float = 0.0

#fov vars
const BASE_FOV: float = 75.0
const FOV_CHANGE: float = 1.5

@export var seetext : Label
@onready var see_cast: RayCast3D = %SeeCast

#@onready var footstep_player = $FootStepsPlayer
var footstep_timer : float = 0.0
const FOOTSTEP_INTERVAL : float = 0.9

signal clicked
@export var cursor : Resource #useless now
@export var footstep_sound_indoor : AudioStream
@export var footstep_sound_outdoor : AudioStream

@export var stats: BaseStats

@onready var input_synchronizer: MultiplayerSynchronizer = %InputSynchronizer

#@export var player_id := 1:
	#set(id):
		#player_id = id
		#print("setting the id")
		#%InputSynchronizer.set_multiplayer_authority(id)

func _enter_tree() -> void:
	# Set authority for both the player and the input synchronizer
	set_multiplayer_authority(name.to_int())
	%InputSynchronizer.set_multiplayer_authority(name.to_int())


func _ready():
	if is_multiplayer_authority():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		camera.current = true
	else: camera.current = false
	
	#Input.set_custom_mouse_cursor(cursor)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#if footstep_sound_indoor:
		#footstep_player.stream = footstep_sound_indoor
		
var current_footstep_sounds: Array[AudioStream] = [] #wtf is this

#func set_footstep_sound(stream: AudioStream) -> void:
	#footstep_player.stream = stream
	
func set_footstep_sounds_random(sounds: Array[AudioStream]) -> void:
	current_footstep_sounds = sounds
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var synced_rotation = input_synchronizer.rotation_input
		
		#head.rotate_y(-event.relative.x * SENSITIVITY)
		#head.rotation.y = clamp(head.rotation.y, deg_to_rad(-90), deg_to_rad(90))
		
		#We should rotate the entire body
		rotate_y(-synced_rotation.x * SENSITIVITY)
		
		camera.rotate_x(-synced_rotation.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-20), deg_to_rad(20))

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	if Input.is_action_pressed("sprint"):
		current_speed = SPRINT_SPEED
	else: current_speed = walk_speed
	
	var synced_input = input_synchronizer.input_dir
	
	var direction = (transform.basis * Vector3(
		synced_input.x, 0, synced_input.y)).normalized()
	
	
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * current_speed  #RUUUUN 
			velocity.z = direction.z * current_speed  #RUUUUN
		else:
			velocity.x = lerp(velocity.x, direction.x * current_speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * current_speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * current_speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * current_speed, delta * 3.0)
	
	#HEAD BOB
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	#FOV
	#var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2.0)
	#var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	#camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()

func _headbob(time : float) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_freq) * bob_amp
	pos.x = cos(time * bob_freq /2) * bob_amp
	return pos


"""
	if is_on_floor() and velocity.length() > 0.1:
		footstep_timer -= delta
		if footstep_timer <= 0.0:
			if current_footstep_sounds.size() > 0:
				footstep_player.stream = current_footstep_sounds[randi() % current_footstep_sounds.size()]
			footstep_player.pitch_scale = randf_range(0.9, 1.3)
			footstep_player.play()
			footstep_timer = FOOTSTEP_INTERVAL
	else:
		footstep_timer = 0.0
		"""
"""
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
"""
