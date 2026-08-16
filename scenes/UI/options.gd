extends Control

@onready var settings: Control = $Settings

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
	settings.show()

func _on_exit_to_menu_button_pressed() -> void:
	NetworkManager.quit_lobby()
