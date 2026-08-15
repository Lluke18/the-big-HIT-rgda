extends Control

@onready var page: TextureRect = $Page
@onready var icon_label: Label = $Icon/IconLabel
@onready var update_mark: TextureRect = $Icon/UpdateMark

var initial_icon_text: String = "[Q] Hitman's Notes"
var updated_icon_text: String = "[Q] Hitman's Notes [Updated!]"

@export var method_steps: Array[MethodStep] = []

@onready var lines: Control = $Page/Lines

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
	update_page()
	NotesManager.update_page.connect(_on_update_page)
	page.hide()
	icon_label.text = initial_icon_text
	update_mark.hide()
	hide_lines()

func hide_lines():
	for line in lines.get_children():
		line.hide()

func update_page():
	for method_step_index in range(0, NotesManager.TOTAL_STEPS):
		if NotesManager.steps_completed[method_step_index] == true:
			method_steps[method_step_index].unlock()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_notes"):
		if page.visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		page.visible = !page.visible
		remove_update_mark()
		
func _on_update_page(method_index: int):
	method_steps[method_index].unlock()
	add_update_mark()

func add_update_mark():
	icon_label.text = updated_icon_text
	update_mark.show()
	
func remove_update_mark():
	icon_label.text = initial_icon_text
	update_mark.hide()
