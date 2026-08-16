extends Node

enum MULTIPLAYER_NETWORK_TYPE { ENET, STEAM }

@export var _players_spawn_node: Node

var active_network_type: MULTIPLAYER_NETWORK_TYPE = MULTIPLAYER_NETWORK_TYPE.ENET
var enet_network_scene := preload("res://scenes/multiplayer/enet_network.tscn")
var steam_network_scene := preload("res://scenes/multiplayer/steam_network.tscn")
var active_network

signal return_to_menu

func _build_multiplayer_network():
	if not active_network:
		print("Setting active_network")
		
		MultiplayerManager.multiplayer_mode_enabled = true
		
		match active_network_type:
			MULTIPLAYER_NETWORK_TYPE.ENET:
				print("Setting network type to ENet")
				_set_active_network(enet_network_scene)
			MULTIPLAYER_NETWORK_TYPE.STEAM:
				print("Setting network type to Steam")
				_set_active_network(steam_network_scene)
			_:
				print("No match for network type!")

func _set_active_network(active_network_scene):
	var network_scene_initialized = active_network_scene.instantiate()
	active_network = network_scene_initialized
	active_network._players_spawn_node = _players_spawn_node
	add_child(active_network)

func become_host(is_dedicated_server = false):
	_build_multiplayer_network()
	MultiplayerManager.host_mode_enabled = true if is_dedicated_server == false else false
	active_network.become_host()
	
func join_as_client(lobby_id = 0):
	_build_multiplayer_network()
	active_network.join_as_client(lobby_id)
	
func list_lobbies():
	_build_multiplayer_network()
	if active_network_type == MULTIPLAYER_NETWORK_TYPE.STEAM:
		active_network.list_lobbies()
	else:
		print("you need to use steam to access lobbies")
func quit_lobby() -> void:
	if multiplayer.is_server():
		close_lobby.rpc()
	else:
		# Ask the server to end the session.
		request_quit_lobby.rpc_id(1)

@rpc("any_peer", "reliable")
func request_quit_lobby() -> void:
	if not multiplayer.is_server():
		return

	close_lobby.rpc()
	
@rpc("authority", "call_local", "reliable")
func close_lobby() -> void:
	return_to_menu.emit()
	_cleanup_multiplayer()
	
func _cleanup_multiplayer() -> void:
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()

	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
