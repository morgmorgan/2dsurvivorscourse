extends CanvasLayer

@onready var panel_container = $%PanelContainer

func _ready():
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_BACK)
	
	get_tree().paused = true
	$%RestartButton.pressed.connect(on_restart_button_pressed)
	$%QuitButton.pressed.connect(quit_to_desktop)
	%QuitToMenuButton.pressed.connect(quit_to_menu)
	
	MetaProgression.save_data()
	
func set_defeat():
	$%TitleLabel.text = "Defeat..."
	$%SubtitleLabel.text = "Your flesh returns to the earth"
	play_jingle(true)
	
func play_jingle(defeat : bool = false):
	if defeat:
		$DefeatSFX.play()
	else:
		$VictorySFX.play()
	
func on_restart_button_pressed():
	get_tree().paused = false
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	
func quit_to_desktop():
	get_tree().quit()
	
func quit_to_menu():
	get_tree().paused = false
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
