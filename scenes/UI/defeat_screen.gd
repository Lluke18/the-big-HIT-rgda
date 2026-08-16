extends Control

@onready var description: Label = $Description

@onready var game_scene_path : String = "res://scenes/levels/Game.tscn"
@onready var lose_jingle: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	hide()
	SignalBus.game_lost.connect(_on_defeat)

func _on_exit_to_menu_pressed() -> void:
	NetworkManager.quit_lobby()

func _on_try_again_pressed() -> void:
	SignalBus.reset_level.emit()
	
func _on_defeat(defeat_description: String):
	lose_jingle.play()
	if multiplayer.is_server():
		show_defeat.rpc(defeat_description)
	else:
		# Ask the server to delete the keys
		show_defeat_for_everyone.rpc_id(1, defeat_description)

@rpc("any_peer", "reliable")
func show_defeat_for_everyone(defeat_description: String) -> void:
	if not multiplayer.is_server():
		return
		
	show_defeat.rpc(defeat_description)
	
@rpc("authority", "call_local", "reliable")
func show_defeat(defeat_description: String):
	description.text = defeat_description
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	SignalBus.disable_npcs.emit()
	show()
