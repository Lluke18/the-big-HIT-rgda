extends Control

@onready var network_manager: Node = $NetworkManager
@onready var main_scene := preload("res://scenes/main.tscn")
@export var start_scene_path: String
@export var multiplayer_ui: Control
@export var lobby_ui: Control
@onready var h_box_container: HBoxContainer = $Players/HBoxContainer

@onready var test_level_scene_path : String = "res://scenes/levels/TestLevel.tscn"

#enum player_select{VAMPIRE, DEVIL, WEREWOLF} useless

func _ready() -> void:
	if OS.has_feature("dedicated_server"):
		print("Starting dedicated server...")
		network_manager.become_host(true)
	lobby_ui.hide()


func _on_button_pressed() -> void: #use steam btn
	SignalBus.steam_activated = true
	print("using steam...")
	SteamManager.initialize_steam()
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	network_manager.active_network_type = network_manager.MULTIPLAYER_NETWORK_TYPE.STEAM




func _on_becomehost_pressed() -> void:
	print("become host pressed")
	network_manager.become_host()
	multiplayer_ui.hide()
	lobby_ui.show()


func _on_joinasclient_pressed() -> void:
	print("Join as player 2")
	join_lobby()
	multiplayer_ui.hide()
	lobby_ui.show()


func _on_listlobbies_pressed() -> void: #LIST STEAM LOBBIES!
	print("listing steam lobbies")
	network_manager.list_lobbies()

func join_lobby(lobby_id = 0):
	print("Joining lobby %s" % lobby_id)
	network_manager.join_as_client(lobby_id)
	multiplayer_ui.hide()
	lobby_ui.show()


func _on_lobby_match_list(lobbies: Array):
	print("On lobby match list")
	for lobby_child in $"VBoxContainer".get_children():
		lobby_child.queue_free()
		
	for lobby in lobbies:
		var lobby_name: String = Steam.getLobbyData(lobby, "name")
		
		if lobby_name != "":
			var lobby_mode: String = Steam.getLobbyData(lobby, "mode")
			
			var lobby_button: Button = Button.new()
			lobby_button.set_text(lobby_name + " | " + lobby_mode)
			lobby_button.set_size(Vector2(100, 30))
			lobby_button.add_theme_font_size_override("font_size", 8)
			
			lobby_button.set_name("lobby_%s" % lobby)
			lobby_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
			lobby_button.connect("pressed", Callable(self, "join_lobby").bind(lobby))
			
			$"VBoxContainer".add_child(lobby_button)

#JOCUL MERGE DOAR DACA DAI RUN SCENE LA MULTIPLAYE LOBBY
func _on_start_game_pressed() -> void:
	if !multiplayer.is_server():
		return
	
	var chosen_classes = []
	var has_duplicates: bool = false
	
	for lobby_char in h_box_container.get_children():
		print("i am a player: ", lobby_char.player_id)
		var peer_id = lobby_char.name.to_int()
		var selection = lobby_char.curr_selection
		
		if selection in chosen_classes:
			has_duplicates = true
			break
		else:
			chosen_classes.append(selection)
			MultiplayerManager.player_characters[peer_id] = selection
	
	if has_duplicates:
		print("DUPLICATES CHOSEN!")
		return
	
	#MultiplayerManager.change_scene_to_everyone.rpc(start_scene_path)
	SignalBus.change_scene.emit(test_level_scene_path)
	
	#loads the main scene with all the players and their coresponding characters
	
