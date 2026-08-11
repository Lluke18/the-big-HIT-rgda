extends Node3D
class_name VampireBat

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal entered_vent
signal exited_vent

var initial_position: Vector3 = Vector3.ZERO

func _ready() -> void:
	initial_position = global_position
	visible = false

func play_fly_in_animation(target_position: Vector3):
	look_at(target_position)
	visible = true
	
	animation_player.play("ArmatureAction")
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target_position, 1.0)
	await tween.finished
	
	visible = false
	global_position = initial_position
	animation_player.stop()
	
	entered_vent.emit()
	
func play_fly_out_animation(target_position: Vector3):
	global_position = target_position
	look_at(initial_position)
	visible = true
	
	animation_player.play("ArmatureAction")
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", initial_position, 1.0)
	await tween.finished
	
	visible = false
	global_position = initial_position
	animation_player.stop()
	
	exited_vent.emit()
