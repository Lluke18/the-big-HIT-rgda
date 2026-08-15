extends Control
class_name MethodStep

@onready var tooltip_scene = preload("res://scenes/UI/Tooltip.tscn")
var tooltip: Tooltip

@export var title: String = "No Title"
@export var description: String = "No description"
@export var unlocked_arrows: Array[Line2D] = []
@onready var circle: TextureRect = $Circle

var label

func _ready() -> void:
	label = get_node("Label")
	if label:
		label.text = "???"
	circle.hide()

func unlock():
	circle.show()
	if label:
		label.text = title
	for arrow in unlocked_arrows:
		arrow.show()

func _on_panel_mouse_entered() -> void:
	tooltip = tooltip_scene.instantiate()
	tooltip.set_text(description)
	add_child(tooltip)

func _on_panel_mouse_exited() -> void:
	if tooltip:
		tooltip.queue_free()
		tooltip = null
