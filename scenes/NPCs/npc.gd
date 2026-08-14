extends CharacterBody3D
class_name NPC #or human?

@export var stats: NPCStats
@export var animated_character: Node3D

@onready var fsm: FiniteStateMachine = $StateMachine

var player = null
@export var players_spawn: Node3D
var players: Array[Player]
#maybe also add the suspicion mechanic here as vars
#or a stats var like the player's

@export var move_speed: float
@export var run_speed: float = move_speed
#@export var route_locations: Array[Marker3D]
@export var route: Node3D

@export var sus_multiplier: float = 1.0
var is_chasing: bool = false
var gravity = 9.8

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

@onready var see_cast: RayCast3D = $SeeCast
@onready var suspicion_bar: SuspicionBar = $SubViewport/SuspicionBar

var initial_position: Vector3

func _ready() -> void:
	SignalBus.disable_npcs.connect(disable)
	
	initial_position = global_position
	await get_tree().create_timer(1).timeout
	#players_spawn = get_node("/root/Main/LevelContainer/Game/Players")
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
	
func reset():
	fsm.current_state = fsm.initial_state
	global_position = initial_position
	is_chasing = false
	process_mode = Node.PROCESS_MODE_INHERIT
	
func disable():
	process_mode = Node.PROCESS_MODE_DISABLED
