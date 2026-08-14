extends Control

@onready var location_label: Label = $LocationLabel

@onready var canvas_layer: PlayerUI = $".."

const NUMBER_OF_VENTS: int = 3
const LOCATION_NAMES: Array[String] = [
	"Bathroom Stall",
	"Storage Room",
	"Whatever"
]
var current_vent_index: int = 0

func _ready() -> void:
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	SignalBus.enter_vent.connect(open)
	
func open(target_vent_index: int):
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

func _on_next_button_pressed() -> void:
	if current_vent_index == (NUMBER_OF_VENTS - 1):
		current_vent_index = 0
	else:
		current_vent_index += 1
	location_label.text = LOCATION_NAMES[current_vent_index]
	SignalBus.switch_to_vent.emit(current_vent_index)
