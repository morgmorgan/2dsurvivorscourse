extends Node

@export var end_screen_scene : PackedScene

var pause_menu_scene = preload("res://scenes/UI/pause_menu.tscn")

func _ready():
	$Entities/Player.health_component.died.connect(on_player_died)
	
func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()

func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	if end_screen_instance == null:
		return
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
