extends State

var has_target: bool = false
var target: Player

func Physics_Update(_delta: float):
	npc.velocity = Vector3.ZERO
	if npc.players.size() == 0:
		return
	
	if !has_target:
		target = npc.players.pick_random()
		has_target = true
	

	if is_instance_valid(target):
		npc.nav_agent.set_target_position(target.global_position)
		var next_nav_point = npc.nav_agent.get_next_path_position()
		npc.velocity = (next_nav_point - npc.global_position).normalized() * npc.move_speed
	else:
		has_target = false
