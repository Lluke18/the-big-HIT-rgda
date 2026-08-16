extends Control

@onready var master_slider: HSlider = $MasterSlider
@onready var music_slider: HSlider = $MusicSlider
@onready var sfx_slider: HSlider = $SFXSlider

func _ready() -> void:
	hide()
	master_slider.value = AudioManager.get_master_volume()
	music_slider.value = AudioManager.get_music_volume()
	sfx_slider.value = AudioManager.get_sfx_volume()

func _on_master_slider_value_changed(value: float) -> void:
	AudioManager.set_master_volume(value)

func _on_music_slider_value_changed(value: float) -> void:
	AudioManager.set_music_volume(value)

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioManager.set_sfx_volume(value)

func _on_close_button_pressed() -> void:
	hide()
