extends Node3D

@onready var stall_5_middle: BathroomStall = $"Stalls/Stall5(Middle)"
@onready var sitting_boss: Node3D = $sitting_boss

@onready var poop_zone: Area3D = $PoopZone

func _ready() -> void:
	sitting_boss.hide()
	stall_5_middle.open_door()

func close_middle_door():
	stall_5_middle.close_door()

func _on_poop_zone_body_entered(body: Node3D) -> void:
	if body is NPC:
		commence_poop_sequence(body)

func commence_poop_sequence(body: Node3D):
	SignalBus.boss_pooping_update.emit(true)
	
	body.hide()
	body.process_mode = Node.PROCESS_MODE_DISABLED
	poop_zone.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	
	sitting_boss.show()
	sitting_boss.get_node("AnimationPlayer").play("mixamo_com")
	close_middle_door()
	
	await get_tree().create_timer(5).timeout
	
	sitting_boss.hide()
	body.process_mode = Node.PROCESS_MODE_INHERIT
	body.show()
	
	stall_5_middle.open_door()
	SignalBus.boss_pooping_update.emit(false)
	
	await get_tree().create_timer(5).timeout
	poop_zone.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
