extends Node

#Music
@export var music_player_gameover: AudioStreamPlayer
@export var MAIN_MENU_SONG: AudioStream
@export var IN_GAME_SONG: AudioStream

#Sfx
@export var WALK_SOUND: AudioStream
@export var INTERACT_SOUND: AudioStream



var _master_bus : int
var _music_bus : int
var _sfx_bus : int

var master_volume : float = 1.0
var music_volume : float = 1.0
var sfx_volume : float = 1.0

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer = $SfxPlayer

func _ready() -> void:
	_master_bus = AudioServer.get_bus_index("Master")
	_music_bus  = AudioServer.get_bus_index("Music")
	_sfx_bus    = AudioServer.get_bus_index("Sfx")
	#music_player.play() 

func set_master_volume(value: float) -> void:
	master_volume = value
	AudioServer.set_bus_volume_db(_master_bus, linear_to_db(value))

func set_music_volume(value: float) -> void:
	music_volume = value
	AudioServer.set_bus_volume_db(_music_bus, linear_to_db(value))

func set_sfx_volume(value: float) -> void:
	sfx_volume = value
	AudioServer.set_bus_volume_db(_sfx_bus, linear_to_db(value))

func get_master_volume() -> float:
	return master_volume

func get_music_volume() -> float:
	return music_volume

func get_sfx_volume() -> float:
	return sfx_volume

func play_music(stream: AudioStream) -> void:
	music_player.stream = stream
	music_player.play()

func stop_music() -> void:
	music_player.stop()

func play_sfx(stream: AudioStream) -> void:
	sfx_player.stream = stream
	sfx_player.play()

func play_gameover_music(stream: AudioStream) -> void:
	music_player_gameover.stream = stream
	music_player_gameover.play()

func stop_gameover_music() -> void:
	music_player_gameover.stop()
