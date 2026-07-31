extends Node3D

@export var network_manager: Node
@export var players_spawn: Node3D

var vampire_scene := preload("res://scenes/characters/character.tscn")
var devil_scene := preload("res://scenes/characters/character.tscn")
var werewolf_scene := preload("res://scenes/characters/character.tscn")


func _ready() -> void:
	if SignalBus.steam_activated:
		network_manager.active_network_type = network_manager.MULTIPLAYER_NETWORK_TYPE.STEAM
	if multiplayer.is_server():
		
		for peer_id in MultiplayerManager.player_characters:
			var selection = MultiplayerManager.player_characters[peer_id]
			var new_player: Node3D #maybe charbody3d or custom class!
			
			match selection:
				0: new_player = vampire_scene.instantiate()
				1: new_player = devil_scene.instantiate()
				2: new_player = werewolf_scene.instantiate()
			
			new_player.name = str(peer_id)
			players_spawn.add_child(new_player, true)
			await get_tree().create_timer(0.5).timeout #ca sa nu se suprapuna
			
"""if OS.has_feature("dedicated_server"):
		print("Starting dedicated server...")
		network_manager.become_host(true) """
