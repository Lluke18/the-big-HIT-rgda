extends Control
@onready var character_name: Label = $characterName
@export var character_select: Array[String]
@export var curr_selection: int = 0
@export var player_id := 1:
	set(id):
		player_id = id
		print("setting the id")
		
		#%InputSynchronizer.set_multiplayer_authority(id)

func _enter_tree() -> void:
	# 1. Grab authority instantly before _ready fires.
	# This requires the parent spawner to set this node's name to the peer ID!
	set_multiplayer_authority(name.to_int())


func _ready() -> void:
	print("peer=", multiplayer.get_unique_id(), 
	" authority=", get_multiplayer_authority())
	if character_select.size() > 0:
		character_name.text = character_select[curr_selection]
	
	if  get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
		set_process_input(false)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_right"):
		if  curr_selection >= 2: return
		curr_selection += 1
		update_text.rpc(curr_selection)

	if Input.is_action_just_pressed("ui_left"):
		if curr_selection <= 0: return
		curr_selection -= 1
		update_text.rpc(curr_selection)
	
@rpc("any_peer", "call_local", "reliable")
func update_text(new_selection: int):
	curr_selection = new_selection
	character_name.text = character_select[curr_selection]
