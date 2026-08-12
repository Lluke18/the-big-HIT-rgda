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
	var local_id = multiplayer.get_unique_id() 
	if local_id != 1:
		rpc_id(1,"go_back_to_lobby")
	else:
		go_back_to_lobby.rpc()

@rpc("any_peer", "call_local", "reliable")
func go_back_to_lobby():
	var lobby_ui = get_node("/root/Main/Lobby")
	if lobby_ui:
		lobby_ui.show()
	test_level.queue_free()
