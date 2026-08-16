extends Node

@onready var state_machine: FiniteStateMachine = $"../StateMachine"


func _ready() -> void:
	SignalBus.call_tony.connect(on_call_received)
	
	
	
func on_call_received():
	print("received call! moneycalling")
	if state_machine.current_state.name != "MoneyCalling":
		state_machine.change_state(state_machine.current_state, "MoneyCalling")
