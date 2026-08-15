extends Control

@onready var multiplayer_lobby: Control = $MultiplayerLobby

func _on_play_button_pressed() -> void:
	multiplayer_lobby.show()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
