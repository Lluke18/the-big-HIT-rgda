extends CanvasLayer
class_name PlayerUI

@onready var crosshair: Panel = $Crosshair
@onready var see_text: Label = $SeeText

func _ready() -> void:
	pass # Replace with function body.

func hide_indications():
	crosshair.hide()
	see_text.hide()
	
func show_indications():
	crosshair.show()
	see_text.show()
