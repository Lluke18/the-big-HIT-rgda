extends MultiplayerSynchronizer
#equivalent to MULTIPLAYER INPUT!
@onready var character: Player = $".."

@export var head: Node3D
var username = ""
@export var input_dir := Vector2.ZERO
var direction

@export var rotation_input := Vector2.ZERO
@onready var walk_sound: AudioStreamPlayer3D = $"../Audio/AudioStreamPlayer3D"

func _ready() -> void:
	#this is why client/2nd player mightn't work
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
		set_process_input(false)

func _physics_process(delta: float) -> void:
	input_dir = Input.get_vector("3D_left", "3D_right", "3D_forward", "3D_backward")
	if input_dir and character.is_on_floor():
		if !walk_sound.playing:
			play_walk_sound.rpc(true)
		#else: 
			#if walk_sound.playing:
				#play_walk_sound.rpc(false)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_input = event.relative

@rpc("call_local", "any_peer", "unreliable")
func play_walk_sound(is_moving: bool):
	if is_moving:
		walk_sound.play()
	else: walk_sound.stop()
