extends State



func Physics_Update(_delta: float):
	npc.velocity = Vector3.ZERO
	if npc.player == null:
		return
	npc.nav_agent.set_target_position(npc.player.global_position)
	var next_nav_point = npc.nav_agent.get_next_path_position()
	npc.velocity = (next_nav_point - npc.global_position).normalized() * npc.move_speed
