extends Node3D

@export var network_manager: Node
@export var players_spawn: Node3D
@export var menu_theme: AudioStream

var vampire_scene := preload("res://scenes/characters/character.tscn")
var devil_scene := preload("res://scenes/characters/character.tscn")
var werewolf_scene := preload("res://scenes/characters/character.tscn")


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	AudioManager.stop_music()
	AudioManager.play_music(menu_theme)
	NetworkManager.return_to_menu.connect(_on_return_to_menu)
	if SignalBus.steam_activated:
		network_manager.active_network_type = network_manager.MULTIPLAYER_NETWORK_TYPE.STEAM
	
	#Nu stiu daca ne mai trebuie
	"""
	if multiplayer.is_server():
		for peer_id in MultiplayerManager.player_characters:
			var selection = MultiplayerManager.player_characters[peer_id]
			var new_player: Node3D #maybe charbody3d or custom class!
			
			match selection:
				0: new_player = vampire_scene.instantiate()
				1: new_player = devil_scene.instantiate()
				2: new_player = werewolf_scene.instantiate()
			
			new_player.name = str(peer_id)
			new_player.add_to_group("character")
			players_spawn.add_child(new_player, true)
			#await get_tree().create_timer(3).timeout #ca sa nu se suprapuna
	"""
			
"""if OS.has_feature("dedicated_server"):
		print("Starting dedicated server...")
		network_manager.become_host(true) """
		
func _on_return_to_menu():
	get_tree().reload_current_scene()
	
