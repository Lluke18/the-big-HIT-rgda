extends State


@export var detected_state_name: String
@onready var suspicion_bar: SuspicionBar = $"../../SubViewport/SuspicionBar"
@export var nav_agent: NavigationAgent3D
@export var wait_timer: Timer
var is_waiting: bool = false
#var route_locations: Array[Marker3D] = [Marker3D.new()]
var position_arr: Array[Vector3]
var curr_pos_index: int = 0

var move_dir: Vector3

func _ready() -> void:
	await get_tree().process_frame
	suspicion_bar.detected_player.connect(on_player_detected)
	#if is_instance_valid(npc.route):
		#for marker in npc.route.get_children():
			#position_arr.append(marker.global_position)
	wait_timer.wait_time = npc.location_wait_time

func Enter():
	if !wait_timer.timeout.is_connected(_on_wait_at_location_timeout):
		wait_timer.timeout.connect(_on_wait_at_location_timeout)
	is_waiting = false
	
	if position_arr.is_empty():
		if is_instance_valid(npc.route):
			for marker in npc.route.get_children():
				position_arr.append(marker.global_position)
	
	nav_agent.set_target_position(position_arr[curr_pos_index])
	
func Physics_Update(delta: float):
	
	if is_waiting:
		return
	
	var next_path_position = nav_agent.get_next_path_position()
	move_dir = npc.global_position.direction_to(next_path_position)
	npc.velocity = move_dir * npc.move_speed
	npc.animated_character.play_walk_animation()
	
	var look_at_target: Vector3 = Vector3(next_path_position.x, npc.global_position.y, next_path_position.z)
	if not npc.global_position.is_equal_approx(look_at_target):
		npc.look_at(look_at_target)
		
	if nav_agent.is_navigation_finished():
		#npc.global_rotation = nav_agent.target_rotation
		#state_transition.emit(self, "Idle")
		npc.velocity = Vector3.ZERO
		is_waiting = true
		npc.animated_character.play_idle_animation()
		
		wait_timer.start()
		return

func Exit():
	npc.velocity = Vector3.ZERO
	wait_timer.stop()


func _on_wait_at_location_timeout() -> void:
	curr_pos_index += 1
	if curr_pos_index >= position_arr.size():
		curr_pos_index = 0
		state_transition.emit(self, "Idle")
	else: Enter()


func on_player_detected():
	state_transition.emit(self, detected_state_name)
