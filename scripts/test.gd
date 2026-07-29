extends Node2D


func _on_button_pressed() -> void:
	print("using steam...")
	SteamManager.initialize_steam()
