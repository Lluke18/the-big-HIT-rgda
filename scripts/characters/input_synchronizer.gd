extends MultiplayerSynchronizer
#equivalent to MULTIPLAYER INPUT!
@onready var character: Player = $".."

@export var head: Node3D
var username = ""
@export var input_dir := Vector2.ZERO
var direction

@export var rotation_input := Vector2.ZERO


func _ready() -> void:
	#this is why client/2nd player mightn't work
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
		set_process_input(false)

func _physics_process(delta: float) -> void:
	input_dir = Input.get_vector("3D_left", "3D_right", "3D_forward", "3D_backward")
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_input = event.relative
