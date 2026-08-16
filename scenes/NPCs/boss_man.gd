extends NPC


@export var bath_route: Node3D
@export var grab_coffee_state: Node
var is_vampire: bool = false
var coffee_has_laxatives: bool = false

func _ready() -> void:
	super()
	SignalBus.laxatives_put.connect(on_laxatives_put)
	SignalBus.drank_coffee_laxative.connect(go_to_bath)
	SignalBus.turn_boss_into_vampire.connect(transform_vampire)


func on_laxatives_put():
	print("THE COFFEE NOW HAS LAXATIVES!")
	coffee_has_laxatives = true
	grab_coffee_state.coffee_has_laxatives = true

func go_to_bath():
	fsm.change_state(fsm.current_state, "GotoBath")
	print("BOSS IS GOING TO POOP!")

func victory():
	grab_coffee_state.victory()
func transform_vampire():
	is_vampire = true
