extends Control

@onready var description_1: Label = $Background/Description1
@onready var description_2: Label = $Background/Description2

@onready var background: TextureRect = $Background

@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var win_jingle: AudioStreamPlayer = $AudioStreamPlayer

var methods_discovered: int = 0

func _ready() -> void:
	hide()
	background.hide()
	SignalBus.game_won.connect(_on_victory)

func count_methods_discovered():
	methods_discovered = 0
	if NotesManager.steps_completed[NotesManager.step.KILL_1] == true:
		methods_discovered += 1
	if NotesManager.steps_completed[NotesManager.step.KILL_2] == true:
		methods_discovered += 1
	if NotesManager.steps_completed[NotesManager.step.KILL_3] == true:
		methods_discovered += 1
	update_description()
		
func update_description():
	match methods_discovered:
		1:
			description_1.text = "You have 2 more methods to kill your target"
			description_2.text = "Do you want to play this mission again?"
		2:
			description_1.text = "You have 1 more method to kill your target"
			description_2.text = "Do you want to play this mission again?"
		3:
			description_1.text = "You have found all kill methods"
			description_2.text = "Good job!"
		_:
			description_1.text = "You have found no method to kill your target"
			description_2.text = "You shouldn't be seeing this screen"

func _on_exit_to_menu_pressed() -> void:
	NetworkManager.quit_lobby()

func _on_try_again_pressed() -> void:
	SignalBus.reset_level.emit()
	
func _on_victory():
	win_jingle.play()
	if multiplayer.is_server():
		show_victory.rpc()
	else:
		# Ask the server to delete the keys
		show_victory_for_everyone.rpc_id(1)

@rpc("any_peer", "reliable")
func show_victory_for_everyone() -> void:
	if not multiplayer.is_server():
		return
		
	show_victory.rpc()
	
@rpc("authority", "call_local", "reliable")
func show_victory():
	show()
	
	SignalBus.disable_npcs.emit()
	count_methods_discovered()
	
	video_stream_player.play()
	await video_stream_player.finished
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	background.show()
