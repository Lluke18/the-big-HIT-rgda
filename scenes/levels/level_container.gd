extends Node

@onready var lobby: Control = $"../Lobby"

func _ready() -> void:
	SignalBus.change_scene.connect(change_scene_to_3d)

func change_scene_to_3d(scene_path: String) -> void:
	lobby.hide()
	
	if not multiplayer.is_server():
		return # Doar serverul are voie să schimbe nivelul în rețea
		
	# 1. Curățăm ecranul de selecție curent (sau scenele vechi) din container
	for child in get_children():
		child.queue_free()
		
	# Așteptăm un cadru pentru ca nodurile vechi să fie șterse complet din memorie
	await get_tree().process_frame
	
	# 2. Încărcăm și instanțiem noua scenă 3D
	var new_level = load(scene_path).instantiate()
	
	# 3. O adăugăm în containerul monitorizat de MultiplayerSpawner
	add_child(new_level)
	
	# Adăugăm local și serverul în joc după ce se creează nivelul
	_spawn_single_player(1)
	
# [SERVER] Funcție centralizată care spawnează un singur jucător
func _spawn_single_player(peer_id: int) -> void:
	if not multiplayer.is_server():
		return
		
	var current_level = get_child(0)
	var players_node = current_level.get_node_or_null("Players")
	
	if players_node:
		# Verificăm să nu existe deja un jucător cu acest ID instanțiat
		if players_node.has_node(str(peer_id)):
			return
			
		var player_scene = load("res://scenes/characters/character.tscn").instantiate()
		player_scene.name = str(peer_id)
		
		# Adăugăm jucătorul în nodul monitorizat de PlayerSpawner-ul din interiorul hărții
		players_node.add_child(player_scene)
		print("Serverul a spawnat cu succes caracterul 3D pentru peer: ", peer_id)
