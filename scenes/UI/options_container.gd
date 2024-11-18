extends MarginContainer
class_name OptionsContainer

signal back_pressed

@onready var sfx_slider = %SfxSlider
@onready var music_slider = %MusicSlider
@onready var back_button = %BackButton

func _ready():
	$%WindowOptionBox.item_selected.connect(on_window_option_selected)
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind("Sound Effects"))
	music_slider.value_changed.connect(on_audio_slider_changed.bind("Music"))
	sfx_slider.value = get_bus_volume_percent("Sound Effects")
	music_slider.value = get_bus_volume_percent("Music")
	back_button.pressed.connect(on_back_button_pressed)
	
	# update window option
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		%WindowOptionBox.selected = 0
	else:
		%WindowOptionBox.selected = 1
	
func on_audio_slider_changed(value : float, bus_name : String):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value))
	
func get_bus_volume_percent(bus_name : String):
	return db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus_name)))

func on_window_option_selected(index):
	match index:
		0: 
			if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1: 
			if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
				
func on_back_button_pressed():
	back_pressed.emit()
	#get_tree().change_scene_to_file("res://scenes/main/main.tscn")
