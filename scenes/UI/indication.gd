extends Label

func _ready() -> void:
	SignalBus.break_cameras.connect(on_cameras_broken)
	self_modulate.a = 1
	text = "Find a way to kill your target!"
	await get_tree().create_timer(4).timeout
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "self_modulate:a", 0, 2)
	
func on_cameras_broken():
	self_modulate.a = 1
	text = "Cameras are now disabled!"
	await get_tree().create_timer(4).timeout
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "self_modulate:a", 0, 2)
