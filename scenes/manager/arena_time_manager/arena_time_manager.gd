extends Node

@onready var timer_node = $Timer

func get_time_elapsed():
	return timer_node.wait_time - timer_node.time_left
