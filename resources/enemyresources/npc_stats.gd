extends Resource
class_name NPCStats

@export var max_hp: int
var curr_hp: int = max_hp
signal died #use it in the fsm to create a death state

enum suspicion{LOW, MID, HIGH}

@export_enum("suspicion") var suspicion_level


func lose_health(amount: int):
	curr_hp -= amount
	if curr_hp < 1:
		print("died!")
		died.emit()

func gain_health(amount: int):
	if curr_hp + amount < max_hp:
		curr_hp += amount
	else: curr_hp = max_hp
