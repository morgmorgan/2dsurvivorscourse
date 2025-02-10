extends CanvasLayer

func _ready():
	get_tree().paused = true
	BgmPlayer.bass_only(true)
	%ResumeButton.pressed.connect(close)
	%QuitButton.pressed.connect(quit_to_desktop)
	%QuitToMenuButton.pressed.connect(quit_to_menu)
	%OptionsButton.pressed.connect(options_pressed)
	$OptionsContainer.back_pressed.connect(options_back_pressed)

func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		get_tree().root.set_input_as_handled()
		close()

func close():
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	BgmPlayer.bass_only(false)
	queue_free()
	
func quit_to_desktop():
	get_tree().quit()
	
func quit_to_menu():
	get_tree().paused = false
	BgmPlayer.bass_only(false)
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
	
func options_pressed():
	$OptionsContainer.visible = true
	$PauseContainer.visible = false

func options_back_pressed():
	$OptionsContainer.visible = false
	$PauseContainer.visible = true
