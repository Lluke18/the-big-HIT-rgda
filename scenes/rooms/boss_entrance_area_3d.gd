extends Area3D

func _on_body_entered(body: Node3D) -> void:
	SignalBus.boss_office_update.emit(true)

func _on_body_exited(body: Node3D) -> void:
	SignalBus.boss_office_update.emit(false)
