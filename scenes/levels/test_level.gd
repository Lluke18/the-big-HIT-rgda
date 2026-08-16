extends Node3D

@export var players_spawn: Node3D
@export var discount: AudioStream # asa se numeste main loopul 
@export var chase_music: AudioStream


var game_level_scene = preload("res://scenes/levels/GameLevel.tscn")
@onready var current_game_level: Node3D = $GameLevel
@onready var alarm: AudioStreamPlayer = $Audio/alarm

@onready var npcs_parent: Node3D = $NPCs
@onready var security_cams: Node3D = $SecurityCams

func _ready() -> void:
	SignalBus.reset_level.connect(_on_level_reset_requested)
	NotesManager.try_to_update_step(NotesManager.step.VENTS)
	NotesManager.try_to_update_step(NotesManager.step.STORAGE)
	NotesManager.try_to_update_step(NotesManager.step.TONY)
	SignalBus.already_lost = false
	
	var main_menu = get_node("/root/Main/MainMenu")
	var lobby = get_node("/root/Main/MainMenu/MultiplayerLobby")
	if main_menu:
		main_menu.hide()
		lobby.hide()
	# Fiecare jucător (atât serverul, cât și clienții) trimite un RPC către server
	# în momentul în care această scenă 3D s-a încărcat complet local
	var local_id = multiplayer.get_unique_id()
	
	# Serverul se spawnează deja din Main, așa că doar clienții cer spawn-ul aici
	if local_id != 1:
		rpc_id(1, "request_spawn_on_server", local_id)
	
	AudioManager.stop_music()
	AudioManager.play_music(discount)
	await get_tree().create_timer(2).timeout
	for player in get_node("Players").get_children():
		player.add_to_group("Player")
		#TREBE SA ADAUG SI PLAYERII SPAWNATI!
		print("THE GAME HAS: ", player)


@rpc("any_peer", "reliable")
func request_spawn_on_server(peer_id: int) -> void:
	if not multiplayer.is_server():
		return
		
	# Apelăm funcția de spawn din scriptul Main
	# get_node("/root/Main") trebuie să corespundă cu numele nodului tău principal
	var level_container = get_node_or_null("/root/Main/LevelContainer")
	if level_container:
		level_container._spawn_single_player(peer_id)
		
func _on_level_reset_requested():
	if not multiplayer.is_server():
		return
	
	restart_level_rpc.rpc()
	
@rpc("authority", "call_local", "reliable")
func restart_level_rpc() -> void:
	reset_level()
	
func reset_level():
	for npc in npcs_parent.get_children():
		if npc is NPC:
			npc.reset()
			
	for cam in security_cams.get_children():
		if cam is SecurityCam:
			cam.reset()
	
	var new_game_level = game_level_scene.instantiate()
	current_game_level.queue_free()
	await get_tree().process_frame
	add_child(new_game_level)
	current_game_level = new_game_level
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_idle_guard_play_alarm() -> void:
	alarm.play()
	await alarm.finished
	AudioManager.play_music(chase_music)
	#await alarm to finish, then play exciting music
