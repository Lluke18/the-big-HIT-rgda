extends State

@export var attack_range:Area3D
@onready var shoot_sound: AudioStreamPlayer = $"../../ShootSound"


func Enter():
	print("entered attack!")
	
	npc.velocity = Vector3.ZERO
	npc.animated_character.play_shoot_animation()
	shoot_sound.play()
	await npc.animated_character.animation_player.animation_finished
	#PLAY SHOOT SOUND HERE!
	if SignalBus.already_lost == false:
		SignalBus.game_lost.emit("The guards got you...")
		SignalBus.already_lost = true
	
