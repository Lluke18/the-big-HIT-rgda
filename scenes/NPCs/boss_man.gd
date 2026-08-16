extends NPC


@export var bath_route: Node3D
@export var grab_coffee_state: Node

func _ready() -> void:
	super()
	SignalBus.laxatives_put.connect(on_laxatives_put)
	SignalBus.drank_coffee_laxative.connect(go_to_bath)
	#SignalBus.


func on_laxatives_put():
	print("THE COFFEE NOW HAS LAXATIVES!")
	grab_coffee_state.coffee_has_laxatives = true

func go_to_bath():
	fsm.change_state(fsm.current_state, "GotoBath")
	print("BOSS IS GOING TO POOP!")
