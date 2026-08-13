extends State

var guard_target: CharacterBody3D
var found_guard: bool = false
@export var idle_state_name: String
@export var guard_detection_area: Area3D
signal intruder_found

func Enter():
	print("entered run to guard")
	found_guard = false
	#go to closest guard and run away from the player!


func Physics_Update(_delta: float):
	
	
	if !found_guard:
		guard_target = get_closest_guard()
		found_guard = true
	
	if is_instance_valid(guard_target):
		#print("found valid guard!")
		npc.nav_agent.set_target_position(guard_target.global_position)
		var next_nav_point = npc.nav_agent.get_next_path_position()
		#add y-flattening if has floor friction or floats
		var direction = next_nav_point - npc.global_position
		direction.y = 0
		
		npc.velocity = direction.normalized() * npc.run_speed
		
		var look_pos = npc.global_position + direction
		npc.look_at(Vector3(look_pos.x, npc.global_position.y, look_pos.z), Vector3.UP)
		npc.animated_character.play_run_animation()
		
	
	var overlapping_bodies = guard_detection_area.get_overlapping_bodies()
	
	for body in overlapping_bodies:
		if body.is_in_group("guard"):
			print("detected guard! switching to Idle")
			state_transition.emit(self, idle_state_name)
			SignalBus.emit_signal("found_intruder")
			npc.velocity = Vector3.ZERO
			break

func get_closest_guard() -> CharacterBody3D:
	var guards = get_tree().get_nodes_in_group("guard")
	
	var min_dist = INF
	var closest_guard: CharacterBody3D
	
	for guard in guards:
		var dist = npc.global_position.distance_to(guard.global_position)
	
		if dist < min_dist:
			min_dist = dist
			closest_guard = guard
			

	return closest_guard
