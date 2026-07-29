extends Node

var is_owned: bool = false
var steam_app_id: int = 480 #spacewar id
var steam_id: int = 0
var steam_username: String = ""

var lobby_id: int = 0
var lobby_max_members: int = 4

#kind of like a constructor, contains the setup
func _init():
	print("Init steam")
	OS.set_environment("SteamAppId", str(steam_app_id))
	OS.set_environment("SteamGameId", str(steam_app_id))
	
func _process(delta: float) -> void:
	Steam.run_callbacks()
	
func initialize_steam():
	var initialize_response: Dictionary = Steam.steamInitEx()
	print("Did steam init?: %s" % initialize_response)
	
	if initialize_response['status'] > 0:
		print("Failed to init Steam! %s " % initialize_response)
		get_tree().quit()
		
	is_owned = Steam.isSubscribed()
	steam_id = Steam.getSteamID()
	steam_username = Steam.getPersonaName()
	
	print("steam id is: ", steam_id)
	
