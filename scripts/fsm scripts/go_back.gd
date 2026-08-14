extends State

@export var nav_agent: NavigationAgent3D

var position_arr = []

var move_dir: Vector3

func Enter():
	for loc in npc.route.get_children():
		position_arr.append(loc.global_position)
	nav_agent.set_target_position(position_arr.pop_back())
	

func Physics_Update(_delta: float):
	var next_path_position = nav_agent.get_next_path_position()
	move_dir = npc.global_position.direction_to(next_path_position)
	npc.velocity = move_dir * npc.move_speed
	npc.animated_character.play_walk_animation()
	
	var look_at_target: Vector3 = Vector3(next_path_position.x, npc.global_position.y, next_path_position.z)
	if not npc.global_position.is_equal_approx(look_at_target):
		npc.look_at(look_at_target)
		
	if nav_agent.is_navigation_finished():
		state_transition.emit(self, "Idle")
