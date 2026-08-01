extends CharacterBody3D
class_name NPC #or human?


var player = null
@export var players_spawn: Node3D
var players: Array[Player]
#maybe also add the suspicion mechanic here as vars
#or a stats var like the player's
@export var move_speed: float
var gravity = 9.8

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D


func _ready() -> void:
	await get_tree().create_timer(1).timeout
	if players_spawn:
		for child in players_spawn.get_children():
			print("i am a child of player spawn, name is: ", child.name)
			players.append(child)
	else: player = get_tree().get_first_node_in_group("character")
	#player = get_node(player_path)

func _physics_process(delta: float) -> void:
	if !multiplayer.is_server():
		return
	
	if !is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()
