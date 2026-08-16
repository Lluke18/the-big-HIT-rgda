extends State

@export var nav_agent: NavigationAgent3D

var position_arr: Array[Vector3]
var current_target: Vector3
@onready var suspicion_bar: SuspicionBar = $"../../SubViewport/SuspicionBar"
var move_dir: Vector3

func _ready() -> void:
	await get_tree().process_frame
	if is_instance_valid(npc.route):
		for marker in npc.route.get_children():
			position_arr.append(marker.global_position)
	position_arr.append(npc.global_position)

func Enter():
	if not suspicion_bar.detected_player.is_connected(on_player_detected):
		suspicion_bar.detected_player.connect(on_player_detected)
		
	if position_arr.is_empty():
		return
	
	pick_new_location()

func Physics_Update(_delta: float):
	if not multiplayer.is_server():
		return
	
	
	var next_path_position = nav_agent.get_next_path_position()
	move_dir = npc.global_position.direction_to(next_path_position)
	
	# Flatten Y-axis to prevent floor friction bugs
	move_dir.y = 0
	
	if move_dir.length_squared() > 0.01:
		move_dir = move_dir.normalized()
		npc.velocity = move_dir * npc.move_speed
		npc.animated_character.play_walk_animation()
		
		var look_at_target: Vector3 = Vector3(next_path_position.x, npc.global_position.y, next_path_position.z)
		if not npc.global_position.is_equal_approx(look_at_target):
			npc.look_at(look_at_target, Vector3.UP)
	else:
		npc.velocity = Vector3.ZERO
		
	if nav_agent.is_navigation_finished():
		npc.velocity = Vector3.ZERO
		npc.animated_character.play_idle_animation()
		state_transition.emit(self, "Idle")

func pick_new_location():
	var valid_locs = []
	
	# Filter out positions close to our current target
	for pos in position_arr:
		if pos.distance_to(current_target) > 0.5:  #weird
			valid_locs.append(pos)
	
	if valid_locs.size() > 0:
		current_target = valid_locs.pick_random()
		nav_agent.target_position = current_target

func Exit():
	if suspicion_bar.detected_player.is_connected(on_player_detected):
		suspicion_bar.detected_player.disconnect(on_player_detected)
	npc.velocity = Vector3.ZERO

func on_player_detected():
	state_transition.emit(self, "RunToGuard")
