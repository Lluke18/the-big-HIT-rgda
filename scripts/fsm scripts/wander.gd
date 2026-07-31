extends State


var move_dir: Vector3

func Enter():
	print("entered wander")
	randomize_wander()

func Physics_Update(delta: float):
	npc.velocity = move_dir * npc.move_speed * delta 

func randomize_wander():
	move_dir = Vector3(randf_range(-1,1), 
	randf_range(-1,1), randf_range(-1,1)).normalized()
