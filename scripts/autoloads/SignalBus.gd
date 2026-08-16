extends Node

enum CLASS{VAMPIRE, DEVIL, WEREWOLF}

var steam_activated: bool = false

signal change_scene(new_scene_path: String)
signal reset_level
signal disable_npcs

signal game_lost(description: String)
signal game_won

signal enter_vent(vent_index: int)
signal switch_to_vent(vent_index: int)
signal exit_vent(vent_index: int, player: Player)
signal found_intruder(intruder_position: Vector3)

signal boss_pooping_update(is_pooping: bool)
signal call_tony
signal break_cameras
signal turn_boss_into_vampire
signal laxatives_put
signal drank_coffee_laxative
signal boss_office_update(is_inside: bool)

var already_lost: bool = false

signal exit_locker(player: Player)
