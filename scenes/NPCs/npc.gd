extends CharacterBody3D
class_name NPC #or human?

@export var stats: NPCStats
var player = null
@export var players_spawn: Node3D
var players: Array[Player]
#maybe also add the suspicion mechanic here as vars
#or a stats var like the player's
#salutare dani
@export var move_speed: float
@export var route_locations: Array[Marker3D]
var gravity = 9.8

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

@onready var see_cast: RayCast3D = $SeeCast
@onready var suspicion_bar: SuspicionBar = $SubViewport/SuspicionBar

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
		#return
		pass
	
	if is_instance_valid(see_cast) and see_cast.is_colliding():
		var target = see_cast.get_collider()
		if target != null and target.is_in_group("player"): # OR MAKE A GROUP!
			suspicion_bar.start_increase()
			#print("NPC sees player!")
		else:
			suspicion_bar.stop_increase()
	else:
		suspicion_bar.stop_increase()
		
	
	if !is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()
