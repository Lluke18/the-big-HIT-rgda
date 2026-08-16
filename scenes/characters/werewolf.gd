extends Player
class_name Werewolf


@onready var werewolf_head: MeshInstance3D = $AnimatedCharacter/RootNode/CharacterArmature/Skeleton3D/BoneAttachment3D/werewolf_head2/Object_7_002
@onready var vision: TextureRect = $CanvasLayer/TextureRect
@onready var growl: AudioStreamPlayer = $growl
const WOLF_MAT = preload("res://assets/materials/wolf_vision.tres")


func _ready():
	super()
	SPRINT_SPEED = 9.0
	print("my sprint speed is: ", SPRINT_SPEED)

func _unhandled_input(event: InputEvent) -> void:
	super(event)
	
	if event.is_action_pressed("e"):
		growl.play()
		enable_wolf_vision(true)
	elif event.is_action_released("e"):
		enable_wolf_vision(false)
	


func _physics_process(delta: float) -> void:
	super(delta)
	
	if not is_multiplayer_authority():
		return
	werewolf_head.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY
	
	
	#region Interaction
	seetext.hide()
	if is_instance_valid(see_cast) and see_cast.is_colliding():
		var target = see_cast.get_collider()
		if target != null and target.is_in_group("interactable"): # OR MAKE A GROUP!
			seetext.text = target.werewolf_interaction_text #Singura diferenta e aici
			seetext.show()
			if Input.is_action_just_pressed("interact"):
				target.interact.call(self)
				animated_character.play_interact_animation()
				print("DO STUFF!")
	#endregion


func enable_wolf_vision(is_active: bool) -> void:
	vision.visible = is_active
	var targets = get_tree().get_nodes_in_group("target")
	for target in targets:
		apply_xray(target, is_active)

func apply_xray(current_node: Node, is_active: bool):
	if current_node is MeshInstance3D:
		if is_active:
			current_node.material_overlay = WOLF_MAT
		else:
			current_node.material_overlay = null      
	for child in current_node.get_children():
		apply_xray(child, is_active)
