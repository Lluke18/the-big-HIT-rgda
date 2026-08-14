extends Control

@onready var description: Label = $Description

@onready var game_scene_path : String = "res://scenes/levels/Game.tscn"

func _ready() -> void:
	hide()
	
	await get_tree().create_timer(5).timeout
	#_on_defeat("")   #uncomment daca vrei sa apara (TEMPORAR)

func _on_defeat(defeat_description: String):
	description.text = defeat_description
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	SignalBus.disable_npcs.emit()
	show()

func _on_exit_to_menu_pressed() -> void:
	NetworkManager.quit_lobby()

func _on_try_again_pressed() -> void:
	SignalBus.reset_level.emit()
