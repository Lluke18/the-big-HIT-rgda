extends Node3D


@export var players_spawn: Node3D


func _ready() -> void:
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
