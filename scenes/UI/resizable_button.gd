extends TextureButton

func _ready() -> void:
	offset_transform_enabled = true
	mouse_entered.connect(zoom_in)
	mouse_exited.connect(zoom_out)

func zoom_in():
	if disabled == false:
		offset_transform_scale = Vector2(1.2,1.2)
	
func zoom_out():
	offset_transform_scale = Vector2(1,1)
