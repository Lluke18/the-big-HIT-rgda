extends Node

var host_mode_enabled = false
var multiplayer_mode_enabled = false
var respawn_point = Vector2(30, 20)

enum character_type{
	VAMPIRE,
	WEREWOLF
}

var player_characters: Dictionary = {}

#MAYBE PUT THIS IS SCENECHANGER!
@rpc("authority", "call_local", "reliable")
func change_scene_to_everyone(scene_path: String):
	get_tree().change_scene_to_file(scene_path)
