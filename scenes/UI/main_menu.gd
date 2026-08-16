extends Control

@onready var multiplayer_lobby: Control = $MultiplayerLobby
@onready var settings: Control = $Settings
@onready var how_to_play: TextureRect = $HowToPlay

func _on_play_button_pressed() -> void:
	multiplayer_lobby.show()
	NotesManager.reset_steps_progress()
	InventoryManager.reset_data()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	settings.show()

func _on_how_to_play_button_pressed() -> void:
	how_to_play.show()

func _on_close_how_button_pressed() -> void:
	how_to_play.hide()
