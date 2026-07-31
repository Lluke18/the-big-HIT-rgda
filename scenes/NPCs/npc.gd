extends CharacterBody3D
class_name NPC #or human?

@export var player_path: NodePath
var player = null
@export var move_speed: float
var gravity = 9.8

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D


func _ready() -> void:
	player = get_tree().get_first_node_in_group("character")
	#player = get_node(player_path)

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()
