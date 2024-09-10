extends Node

@export var end_screen_scene : PackedScene

@onready var timer_node = $Timer

func _ready():
	timer_node.timeout.connect(on_timer_timeout)

func get_time_elapsed():
	return timer_node.wait_time - timer_node.time_left

func on_timer_timeout():
	var end_screen_instance = end_screen_scene.instantiate()
	if end_screen_instance == null:
		return
	add_child(end_screen_instance)
