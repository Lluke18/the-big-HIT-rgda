extends Control

@onready var kill_button: TextureButton = $KillButton

func _ready() -> void:
	hide()
	kill_button.disabled = true
	SignalBus.boss_office_update.connect(_on_boss_office_update)

func _on_boss_office_update(is_inside: bool):
	if is_inside:
		kill_button.disabled = false
	else:
		kill_button.disabled = true

func _on_exit_button_pressed() -> void:
	print("AM apasat exit")
	var player = get_parent().get_parent()
	SignalBus.exit_locker.emit(player)
	hide()

func _on_kill_button_pressed() -> void:
	if multiplayer.is_server():
		win_game.rpc()
	else:
		# Ask the server to delete the keys
		win_game_for_everyone.rpc_id(1)

@rpc("any_peer", "reliable")
func win_game_for_everyone() -> void:
	if not multiplayer.is_server():
		return
		
	win_game.rpc()
	
@rpc("authority", "call_local", "reliable")
func win_game():
	NotesManager.try_to_update_step(NotesManager.step.KILL_3)
	SignalBus.game_won.emit()
