extends Control
class_name MethodStep

@onready var tooltip_scene = preload("res://scenes/UI/Tooltip.tscn")
var tooltip: Tooltip

@export var title: String = "No Title"
@export var description: String = "No description"

var label

func _ready() -> void:
	label = get_node("Label")
	if label:
		label.text = "???"

func unlock():
	if label:
		label.text = title

func _on_panel_mouse_entered() -> void:
	tooltip = tooltip_scene.instantiate()
	tooltip.set_text(description)
	add_child(tooltip)

func _on_panel_mouse_exited() -> void:
	if tooltip:
		tooltip.queue_free()
		tooltip = null
