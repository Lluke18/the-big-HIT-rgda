extends Control

@onready var page: TextureRect = $Page
@onready var icon_label: Label = $Icon/IconLabel

var initial_icon_text: String = "[Q] Hitman's Notes"
var updated_icon_text: String = "[Q] Hitman's Notes [Updated!]"

@onready var method_steps_parent: Control = $Page/MethodStepsParent
var method_steps: Array[MethodStep] = []
const TOTAL_METHODS = 15

enum step{
	VENTS, #0
	STORAGE, #1
	LAXATIVES, #2
	BATHROOM, #3
	KILL_1, #4
	CAMERAS, #5
	KEYS, #6
	VAMPIRE, #7
	KILL_2, #8
	TONY, #9
	OFFICE, #10
	KILL_3, #11
	GARLIC, #12
	SANDWICH, #13
	PHONE, #14
}

func _ready() -> void:
	initialize_array()
	NotesManager.update_page.connect(_on_update_page)
	page.hide()
	InventoryManager.inventory_modified.connect(_add_update_mark)
	icon_label.text = initial_icon_text

func initialize_array():
	method_steps.resize(15)
	for method_step in method_steps_parent.get_children():
		method_steps.append(method_step)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_notes"):
		page.visible = !page.visible
		_remove_update_mark()
		
func _on_update_page(method_index: int):
	method_steps[method_index].unlock()

func _add_update_mark():
	icon_label.text = updated_icon_text
	
func _remove_update_mark():
	icon_label.text = initial_icon_text
