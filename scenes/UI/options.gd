extends Control

@onready var settings: Control = $Settings
@onready var test_level: Node3D = $"../.."

func _ready() -> void:
	hide()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		"""
		var current_scene = get_tree().current_scene
		if current_scene.name == "GameOver" or current_scene.name == "main_menu":
			return
		"""
		if settings and settings.visible:
			settings.visible = false
			return
		if visible:
			_on_resume_button_pressed()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			show()

func _on_resume_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()

func _on_settings_button_pressed() -> void:
	pass # Replace with function body.

func _on_exit_to_menu_button_pressed() -> void:
	if multiplayer.multiplayer_peer:
		_go_back_to_main_menu.rpc()
		
		
		
		#get_tree().reload_current_scene()
	#multiplayer.multiplayer_peer.disconnect_peer(local_id)
	#multiplayer.peer_disconnected.connect(go_back_to_main_menu)
	
	#go_back_to_main_menu()
		

func go_back_to_main_menu():
	rpc("_go_back_to_main_menu")

@rpc("any_peer", "call_local", "reliable")
func _go_back_to_main_menu():
	#test_level.process_mode = Node.PROCESS_MODE_DISABLED
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	
	get_tree().reload_current_scene()
	
	"""
	test_level.process_mode = Node.PROCESS_MODE_DISABLED
	var main_menu = get_node("/root/Main/MainMenu")
	if main_menu:
		main_menu.show()
	test_level.queue_free()
	"""
