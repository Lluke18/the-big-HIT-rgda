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

@onready var animated_character: AnimatedCharacter = $AnimatedCharacter

#@onready var footstep_player = $FootStepsPlayer
var footstep_timer : float = 0.0
const FOOTSTEP_INTERVAL : float = 0.9

signal clicked
@export var cursor : Resource #useless now
@export var footstep_sound_indoor : AudioStream
@export var footstep_sound_outdoor : AudioStream

@export var stats: BaseStats

@onready var input_synchronizer: MultiplayerSynchronizer = %InputSynchronizer

@onready var player_tag: Label3D = $PlayerTag

var initial_position: Vector3 = Vector3.ZERO

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
	initial_position = global_position
	animated_character.play_idle_animation()
	SignalBus.reset_level.connect(on_reset_players)
	
	player_tag.text = SteamManager.steam_username
	
	if is_multiplayer_authority():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		camera.make_current()
	else:
		#Nu stiu daca asta ar fi solutia ideala
		var new_camera = get_node("/root/Main/LevelContainer/Game/Players/1/head/SpringArm3D/Camera3D")
		new_camera.make_current()
	
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
	if not is_multiplayer_authority():
		return
	if event is InputEventMouseMotion:
		var synced_rotation = input_synchronizer.rotation_input
		
		#head.rotate_y(-event.relative.x * SENSITIVITY)
		#head.rotation.y = clamp(head.rotation.y, deg_to_rad(-90), deg_to_rad(90))
		
		#We should rotate the entire body
		rotate_y(-synced_rotation.x * SENSITIVITY)
		
		camera.rotate_x(-synced_rotation.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-20), deg_to_rad(20))

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	#region Movement
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
			if current_speed == SPRINT_SPEED:
				animated_character.play_run_animation()
			else:
				animated_character.play_walk_animation()
			velocity.x = direction.x * current_speed  #RUUUUN 
			velocity.z = direction.z * current_speed  #RUUUUN
		else:
			animated_character.play_idle_animation()
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
	#endregion
	
	#Subclasele Vampire si Werewolf se ocupa de verificarea interactiunilor

func _headbob(time : float) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_freq) * bob_amp
	pos.x = cos(time * bob_freq /2) * bob_amp
	return pos
	
func on_reset_players():
	if multiplayer.is_server():
		reset_position.rpc()
	else:
		# Ask the server to delete the keys
		reset_position_for_everyone.rpc_id(1)

@rpc("any_peer", "reliable")
func reset_position_for_everyone() -> void:
	if not multiplayer.is_server():
		return
		
	reset_position.rpc()
	
@rpc("any_peer", "call_local", "reliable")
func reset_position():
	global_position = initial_position 
