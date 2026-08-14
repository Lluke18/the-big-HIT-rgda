extends State

@export var nav_agent: NavigationAgent3D


#var route_locations: Array[Marker3D] = [Marker3D.new()]
var position_arr: Array[Vector3]
var curr_position: Vector3
@onready var suspicion_bar: SuspicionBar = $"../../SubViewport/SuspicionBar"
var move_dir: Vector3

func _ready() -> void:
	#route_locations = npc.route_locations #from NPC
	#animated_character.play_walk_animation()
	for marker in npc.route.get_children():
		position_arr.append(marker.global_position)
	position_arr.append(npc.global_position)
	curr_position = npc.global_position

func Enter():
	suspicion_bar.detected_player.connect(on_player_detected)
	if position_arr.is_empty():
		return
	
	pick_new_location()

func Physics_Update(delta: float):
	var next_path_position = nav_agent.get_next_path_position()
	move_dir = npc.global_position.direction_to(next_path_position)
	npc.velocity = move_dir * npc.move_speed
	npc.animated_character.play_walk_animation()
	
	var look_at_target: Vector3 = Vector3(next_path_position.x, npc.global_position.y, next_path_position.z)
	if not npc.global_position.is_equal_approx(look_at_target):
		npc.look_at(look_at_target)
		
	if nav_agent.is_navigation_finished():
		#npc.global_rotation = nav_agent.target_rotation
		state_transition.emit(self, "Idle")

func pick_new_location():
	var valid_locs = []
	for pos in position_arr:
		if pos != curr_position:
			valid_locs.append(pos)
	
	var new_location = valid_locs.pick_random()
	while npc.global_position.is_equal_approx(new_location):
		new_location = position_arr.pick_random()
	nav_agent.target_position = new_location
	
	
func Exit():
	suspicion_bar.disconnect("detected_player", on_player_detected)
	npc.velocity = Vector3.ZERO

#CAN ABSTRACT IT INTO A CORPOSTATE LAYER!
func on_player_detected():
	state_transition.emit(self, "RunToGuard")
