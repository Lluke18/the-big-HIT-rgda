extends Control

@onready var description: Label = $Description

@onready var game_scene_path : String = "res://scenes/levels/Game.tscn"

func _ready() -> void:
	hide()

func _on_defeat(defeat_description: String):
	description.text = defeat_description
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show()

func _on_exit_to_menu_pressed() -> void:
	NetworkManager.quit_lobby()

func _on_try_again_pressed() -> void:
	SignalBus.change_scene.emit(game_scene_path)
