extends Control

@onready var resizable_button_arrow_left: TextureButton = $ResizableButtonArrowLeft
@onready var resizable_button_arrow_right: TextureButton = $ResizableButtonArrowRight

@onready var vampire_image: TextureRect = $VampireImage
@onready var werewolf_image: TextureRect = $WerewolfImage

@onready var character_name: Label = $CharacterBorder/characterName

@onready var steam_name: Label = $SteamName

@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer

@export var character_select: Array[String]
@export var curr_selection: MultiplayerManager.character_type = MultiplayerManager.character_type.VAMPIRE
@export var player_id := 1:
	set(id):
		if player_id == id:
			return
			
		player_id = id
		print("setting the id")
		
		if is_inside_tree():
			_update_synchronizer_authority(id)
		
		#%InputSynchronizer.set_multiplayer_authority(id)

func _enter_tree() -> void:
	# 1. Grab authority instantly before _ready fires.
	# This requires the parent spawner to set this node's name to the peer ID!
	
	_apply_authority_from_name()


func _ready() -> void:
	resizable_button_arrow_left.disabled = true
	resizable_button_arrow_right.disabled = false
	vampire_image.show()
	werewolf_image.hide()
	
	_apply_authority_from_name()
	
	print("peer=", multiplayer.get_unique_id(), 
	" authority=", get_multiplayer_authority())
	if character_select.size() > 0:
		character_name.text = character_select[curr_selection]
	
	steam_name.text = SteamManager.steam_username
	
	if  get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
		set_process_input(false)

func _apply_authority_from_name() -> void:
	var node_auth = name.to_int()
	# Dacă numele nodului este un ID valid de peer (mai mare de 0)
	if node_auth > 0:
		if get_multiplayer_authority() != node_auth:
			set_multiplayer_authority(node_auth)
		_update_synchronizer_authority(node_auth)
		# Sincronizăm și variabila internă ca să fie aceeași cu autoritatea
		player_id = node_auth

func _update_synchronizer_authority(auth_id: int) -> void:
	var synchronizer = find_child("MultiplayerSynchronizer", true, false)
	if not synchronizer:
		synchronizer = find_child("InputSynchronizer", true, false)
		
	if synchronizer and synchronizer.get_multiplayer_authority() != auth_id:
		synchronizer.set_multiplayer_authority(auth_id)
		print("Autoritate sincronizator aliniată la: ", auth_id)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_right"):
		pass
		"""
		if curr_selection >= 1: return
		curr_selection += 1
		update_text.rpc(curr_selection)
		"""

	if Input.is_action_just_pressed("ui_left"):
		pass
		"""
		if curr_selection <= 0: return
		curr_selection -= 1
		update_text.rpc(curr_selection)
		"""
	
@rpc("any_peer", "call_local", "reliable")
func update_text(new_selection: int):
	curr_selection = new_selection
	character_name.text = character_select[curr_selection]

func _on_resizable_button_arrow_left_pressed() -> void:
	if not is_multiplayer_authority():
		return
	if curr_selection <= 0: return
	curr_selection -= 1
	update_text.rpc(curr_selection)
	
	resizable_button_arrow_left.disabled = true
	resizable_button_arrow_right.disabled = false
	vampire_image.show()
	werewolf_image.hide()

func _on_resizable_button_arrow_right_pressed() -> void:
	if not is_multiplayer_authority():
		return
	if curr_selection >= 1: return
	curr_selection += 1
	update_text.rpc(curr_selection)
	
	resizable_button_arrow_left.disabled = false
	resizable_button_arrow_right.disabled = true
	vampire_image.hide()
	werewolf_image.show()
