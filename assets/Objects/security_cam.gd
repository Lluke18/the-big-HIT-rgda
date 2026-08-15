extends Node3D


@onready var see_cast: RayCast3D = $SeeCast
@export var vision_range: float = 10.0
@export var fov: float = 180.0
var already_called: bool = false

@export var player_seen: bool = false
@onready var suspicion_bar: SuspicionBar = $SubViewport/SuspicionBar
@onready var red_light: SpotLight3D = $FogVolume/SpotLight3D
@onready var cam_mesh: MeshInstance3D = $NurbsPath




func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		var live_players = get_tree().get_nodes_in_group("player")
		player_seen = check_for_players(live_players)
		
		if !player_seen:
			red_light.rotation_degrees = Vector3(0, -180, 0)
	
	if player_seen:
		suspicion_bar.start_increase()
	else:
		suspicion_bar.stop_increase()
		
	if suspicion_bar.value == suspicion_bar.max_value and !already_called:
		already_called = true
		#so that this signal fires only ONCE!
		SignalBus.found_intruder.emit()
		suspicion_bar.process_mode = Node.PROCESS_MODE_DISABLED
	
func check_for_players(player_arr: Array) -> bool:
	for player in player_arr:
		#we check distance
		var dist = global_position.distance_to(player.global_position)
		if dist > vision_range:
			continue
		
		#now we angle check
		var dir_to_player = global_position.direction_to(player.global_position)
		var forward = -global_transform.basis.z
		#our forward is actually Z, not -Z
		
		var ang_to_player = rad_to_deg(forward.angle_to(dir_to_player))
		if ang_to_player > fov / 2.0:
			continue
		
		#finally, we aim the cast(line of sight check)
		var aim_target = player.global_position + Vector3(0,1.0,0)
		see_cast.target_position = see_cast.to_local(aim_target)
		see_cast.force_raycast_update()
		
		if see_cast.is_colliding() and see_cast.get_collider().is_in_group("player"):
			red_light.look_at(player.global_position + Vector3(0,0.3,0))
			cam_mesh.look_at(aim_target, Vector3.UP)
			cam_mesh.rotate_object_local(Vector3.UP, deg_to_rad(-90))
			return true
	return false

func disable():
	process_mode = Node.PROCESS_MODE_DISABLED
