extends Control

@onready var location_label: Label = $LocationBorder/LocationLabel
@onready var canvas_layer: PlayerUI = $".."
@onready var kill_ui: Control = $KillUI
@onready var exit_button: TextureButton = $ExitButton

const NUMBER_OF_VENTS: int = 4
const LOCATION_NAMES: Array[String] = [
	"Bathroom Stall",
	"Cubicles",
	"Security Room",
	"Storage Room"
]
var current_vent_index: int = 1

var boss_pooping: bool = false

func _ready() -> void:
	hide()
	kill_ui.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	SignalBus.enter_vent.connect(open)
	SignalBus.boss_pooping_update.connect(update_kill_ui)
	SignalBus.reset_level.connect(on_reset_vent_ui)
	
func on_reset_vent_ui():
	current_vent_index = 1
	hide()
	
func update_kill_ui(is_pooping: bool):
	boss_pooping = is_pooping
	
	if current_vent_index == 0 and boss_pooping:
		kill_ui.show()
		exit_button.disabled = true
	else:
		kill_ui.hide()
		exit_button.disabled = false
	
func open(target_vent_index: int):
	if target_vent_index == 0 and boss_pooping:
		kill_ui.show()
		exit_button.disabled = true
		
	current_vent_index = target_vent_index
	location_label.text = LOCATION_NAMES[current_vent_index]
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#canvas_layer.hide_indications()
	show()

func _on_exit_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#canvas_layer.show_indications()
	hide()
	var player = get_parent().get_parent()
	SignalBus.exit_vent.emit(current_vent_index, player)

func _on_previous_button_pressed() -> void:
	if current_vent_index == 0:
		current_vent_index = NUMBER_OF_VENTS - 1
	else:
		current_vent_index -= 1
	location_label.text = LOCATION_NAMES[current_vent_index]
	SignalBus.switch_to_vent.emit(current_vent_index)
	
	if current_vent_index == 0 and boss_pooping:
		kill_ui.show()
		exit_button.disabled = true
	else:
		kill_ui.hide()
		exit_button.disabled = false

func _on_next_button_pressed() -> void:
	if current_vent_index == (NUMBER_OF_VENTS - 1):
		current_vent_index = 0
	else:
		current_vent_index += 1
	location_label.text = LOCATION_NAMES[current_vent_index]
	SignalBus.switch_to_vent.emit(current_vent_index)
	
	if current_vent_index == 0 and boss_pooping:
		kill_ui.show()
		exit_button.disabled = true
	else:
		kill_ui.hide()
		exit_button.disabled = false
		
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
	NotesManager.try_to_update_step(NotesManager.step.KILL_1)
	SignalBus.game_won.emit()

func _on_bite_button_pressed() -> void:
	if multiplayer.is_server():
		turn_into_vampire.rpc()
	else:
		# Ask the server to delete the keys
		turn_into_vampire_for_everyone.rpc_id(1)

@rpc("any_peer", "reliable")
func turn_into_vampire_for_everyone() -> void:
	if not multiplayer.is_server():
		return
		
	turn_into_vampire.rpc()
	
@rpc("authority", "call_local", "reliable")
func turn_into_vampire():
	NotesManager.try_to_update_step(NotesManager.step.VAMPIRE)
	SignalBus.turn_boss_into_vampire.emit()
