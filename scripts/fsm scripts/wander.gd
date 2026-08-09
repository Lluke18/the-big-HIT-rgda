extends State

@export var nav_agent: NavigationAgent3D

var route_locations: Array[Marker3D] = [Marker3D.new()]

var move_dir: Vector3

func _ready() -> void:
	route_locations = get_parent().get_parent().route_locations #from NPC
	#animated_character.play_walk_animation()

func Enter():
	print("entered wander")
	#randomize_wander()
	pick_new_location()

func Physics_Update(delta: float):
	var next_path_position = nav_agent.get_next_path_position()
	move_dir = npc.global_position.direction_to(next_path_position)
	npc.velocity = move_dir * npc.move_speed
	get_parent().animated_character.play_walk_animation()
	
	var look_at_target: Vector3 = Vector3(next_path_position.x, npc.global_position.y, next_path_position.z)
	if not npc.global_position.is_equal_approx(look_at_target):
		npc.look_at(look_at_target)
		
	if nav_agent.is_navigation_finished():
		state_transition.emit(self, "Idle")

func randomize_wander():
	move_dir = Vector3(randf_range(-1,1), 
	randf_range(-1,1), randf_range(-1,1)).normalized()
	
func pick_new_location():
	var new_location = route_locations.pick_random()
	while npc.global_position.is_equal_approx(new_location.global_position):
		new_location = route_locations.pick_random()
	nav_agent.target_position = new_location.global_position
	
func Exit():
	npc.velocity = Vector3.ZERO
	
