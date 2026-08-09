extends State

@onready var idle_timer: Timer = $IdleTimer

func Enter():
	idle_timer.wait_time = 1 + randf()
	idle_timer.start()
	get_parent().animated_character.play_idle_animation()

func _on_idle_timer_timeout() -> void:
	state_transition.emit(self, "Wander")
