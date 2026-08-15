extends State

var has_target: bool = false
var target: Player
@export var attack_range: Area3D
var emitted_alarm: bool = false

func Enter():
	npc.is_chasing = true
	print("entered chase state")
	#SignalBus.emit_signal("found_intruder")
	if !emitted_alarm:
		emitted_alarm = true
		SignalBus.emit_signal("found_intruder")
	if npc.name == "idle_guard":
		npc.play_alarm.emit()
	#maybe freeze the bar and lock it and 100%
	npc.suspicion_bar.value = npc.suspicion_bar.max_value
	npc.suspicion_bar.process_mode = Node.PROCESS_MODE_DISABLED

func Physics_Update(_delta: float):
	
	if npc.players.size() == 0:
		print("NO PLAYERS SIZE!")
		return
	
	if !has_target: # or is instance valid
		target = get_closest_player()
		has_target = true
	
	if is_instance_valid(target):
		npc.nav_agent.set_target_position(target.global_position)
		var next_nav_point = npc.nav_agent.get_next_path_position()
		var dir = next_nav_point - npc.global_position
		dir.y = 0
		npc.velocity = dir.normalized() * npc.run_speed
		
		var look_pos = npc.global_position + dir
		npc.look_at(Vector3(look_pos.x, npc.global_position.y, look_pos.z), Vector3.UP)
		
		npc.animated_character.play_run_animation()
	else:
		npc.velocity = Vector3.ZERO
		has_target = false
	
	var overlapping_bodies = attack_range.get_overlapping_bodies()
	
	for body in overlapping_bodies:
		if body.is_in_group("Player"):
			print("Detected player, SHOOTIN'")
			state_transition.emit(self, "Attack")
			npc.velocity = Vector3.ZERO
			break

func get_closest_player() -> CharacterBody3D:
	var players = npc.players_spawn.get_children()
	
	var min_dist = INF
	var closest_player: CharacterBody3D
	
	for player in players:
		var dist = npc.global_position.distance_to(player.global_position)
		
		
		if dist < min_dist:
			min_dist = dist
			closest_player = player
			
	return closest_player
