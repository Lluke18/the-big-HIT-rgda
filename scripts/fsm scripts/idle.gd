extends State

@onready var idle_timer: Timer = $IdleTimer
@export var wander_state_name: String
@export var suspicion_bar: SuspicionBar
@export var detected_state_name: String
@export var idle_time: float
@export var idle_time_deviation: float

func _ready() -> void:
	suspicion_bar.detected_player.connect(on_player_detected)

func Enter():
	print(name, "entered Idle!")
	if npc.nav_agent:
		npc.nav_agent.target_position = npc.global_position
	idle_timer.wait_time = idle_time + randf_range(idle_time_deviation, idle_time_deviation * 2)
	idle_timer.start()
	await get_tree().create_timer(0.5).timeout
	npc.animated_character.play_idle_animation()

func _on_idle_timer_timeout() -> void:
	if wander_state_name != null:
		state_transition.emit(self, wander_state_name)

func on_player_detected():
	if detected_state_name != null:
		print("changing to detected state")
		state_transition.emit(self, detected_state_name)
