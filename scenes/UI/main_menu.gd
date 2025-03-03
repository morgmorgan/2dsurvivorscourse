extends CanvasLayer


func _ready():
	$%PlayButton.pressed.connect(on_pressed_play)
	$"%UpgradesButton".pressed.connect(on_upgradeButton_pressed)
	$%OptionsButton.pressed.connect(on_pressed_options)
	$%QuitButton.pressed.connect(on_pressed_quit)
	
func on_pressed_play():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	
func on_upgradeButton_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/meta_upgrade_menu.tscn")

func on_pressed_options():
	get_tree().change_scene_to_file("res://scenes/UI/options_menu.tscn")

func on_pressed_quit():
	get_tree().quit()
