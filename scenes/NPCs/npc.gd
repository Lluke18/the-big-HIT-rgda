extends CharacterBody3D
class_name NPC #or human?

@export var stats: NPCStats
@export var animated_character: Node3D

@onready var fsm: FiniteStateMachine = $StateMachine
@onready var red_light: SpotLight3D = $FogVolume/SpotLight3D

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
@export var location_wait_time: float

@onready var see_cast: RayCast3D = $SeeCast
@export var vision_range: float = 10.0
@export var fov: float = 90.0

@export var player_seen: bool = false
var was_seen: bool = false
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
	#else: player = get_tree().get_first_node_in_group("character")
	#player = get_node(player_path)

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		var live_players = get_tree().get_nodes_in_group("player")
		player_seen = check_for_players(live_players)
		
		if !player_seen:
			red_light.rotation_degrees = Vector3(-154.3, 0, 0)
	
		if !is_on_floor():
			velocity.y -= gravity * delta
	
		move_and_slide()
		
	if player_seen:
		suspicion_bar.start_increase()
	else:
		suspicion_bar.stop_increase()
	

	
func reset():
	fsm.current_state = fsm.initial_state
	global_position = initial_position
	is_chasing = false
	process_mode = Node.PROCESS_MODE_INHERIT

func disable():
	process_mode = Node.PROCESS_MODE_DISABLED

func check_for_players(player_arr: Array) -> bool:
	for player in player_arr:
		#we check distance
		var dist = global_position.distance_to(player.global_position)
		if dist > vision_range:
			continue
		
		#now we angle check
		var dir_to_player = global_position.direction_to(player.global_position)
		var forward = -global_transform.basis.z
		#our forward is actually Z, not -Z
		
		var ang_to_player = rad_to_deg(forward.angle_to(dir_to_player))
		if ang_to_player > fov / 2.0:
			continue
		
		#finally, we aim the cast(line of sight check)
		var aim_target = player.global_position + Vector3(0,1.0,0)
		see_cast.target_position = see_cast.to_local(aim_target)
		see_cast.force_raycast_update()
		
		if see_cast.is_colliding() and see_cast.get_collider().is_in_group("player"):
			red_light.look_at(player.global_position + Vector3(0,0.3,0))
			return true
	return false
