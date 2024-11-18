extends CanvasLayer


func _ready():
	$%PlayButton.pressed.connect(on_pressed_play)
	$%OptionsButton.pressed.connect(on_pressed_options)
	$%QuitButton.pressed.connect(on_pressed_quit)
	
func on_pressed_play():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func on_pressed_options():
	get_tree().change_scene_to_file("res://scenes/UI/options_menu.tscn")

func on_pressed_quit():
	get_tree().quit()
