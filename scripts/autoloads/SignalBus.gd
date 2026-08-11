extends Node

enum CLASS{VAMPIRE, DEVIL, WEREWOLF}

var steam_activated: bool = false

signal change_scene(new_scene_path: String)

signal enter_vent(vent_index: int)
signal switch_to_vent(vent_index: int)
signal exit_vent(vent_index: int, player: Player)
