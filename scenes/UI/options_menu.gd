extends CanvasLayer

func _ready():
	$OptionsContainer.back_pressed.connect(on_back_pressed)

func on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
