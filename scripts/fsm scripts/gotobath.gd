extends State

@export var detected_state_name: String
@onready var suspicion_bar: SuspicionBar = $"../../SubViewport/SuspicionBar"
@export var nav_agent: NavigationAgent3D
@export var wait_timer: Timer
var is_waiting: bool = false
#var route_locations: Array[Marker3D] = [Marker3D.new()]
var position_arr: Array[Vector3]
var curr_pos_index: int = 0
@onready var boss_area: Area3D = $"../../GuardDetectionArea"

@export var door_timer: Timer

var is_opening_doors: bool
var opened_doors: Array = []

var move_dir: Vector3

var is_vampire: bool = false
var coffee_has_laxatives: bool = false


func _ready() -> void:
	await get_tree().process_frame
	suspicion_bar.detected_player.connect(on_player_detected)
	#if is_instance_valid(npc.route):
		#for marker in npc.route.get_children():
			#position_arr.append(marker.global_position)
	wait_timer.wait_time = npc.location_wait_time
	SignalBus.turn_boss_into_vampire.connect(on_turn_into_vampire)
	
func on_turn_into_vampire():
	is_vampire = true

func Enter():
	print("boss is going TO BATH")
	if !wait_timer.timeout.is_connected(_on_wait_at_location_timeout):
		wait_timer.timeout.connect(_on_wait_at_location_timeout)
	is_waiting = false
	
	if position_arr.is_empty():
		if is_instance_valid(npc.bath_route):
			for marker in npc.bath_route.get_children():
				position_arr.append(marker.global_position)
	
	nav_agent.set_target_position(position_arr[curr_pos_index])

func Physics_Update(_delta: float):
	if is_waiting or is_opening_doors:
		return

	#DOOR LOGIC:
	for body in boss_area.get_overlapping_bodies():
		if body.is_in_group("door") and !opened_doors.has(body.get_parent()):
			print("DETECTED A DOOR1!")
			opened_doors.append(body.get_parent())
			
			is_opening_doors = true
			npc.velocity = Vector3.ZERO
			npc.animated_character.play_idle_animation()
			if multiplayer.is_server():
				var door_node = body.get_parent()
				door_node.npc_opens_door.rpc()
				await door_node.animation_player.animation_finished
			is_opening_doors = false
			door_timer.start()
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
		print("reached a point!")
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

func _on_door_timer_timeout() -> void:
	if not opened_doors.is_empty():
		if opened_doors[0] != null:
			opened_doors[0].animation_player.play_backwards("OpenDoor")
			opened_doors.pop_front()
		


func victory():
	if multiplayer.is_server():
		win_game.rpc()
	else:
		# Ask the server to delete the keys
		win_game_for_everyone.rpc_id(1)

@rpc("any_peer", "reliable")
func win_game_for_everyone() -> void:
	if not multiplayer.is_server():
		return
		
	win_game.rpc()
	
@rpc("authority", "call_local", "reliable")
func win_game():
	is_vampire = false
	NotesManager.try_to_update_step(NotesManager.step.KILL_2)
	SignalBus.game_won.emit()
