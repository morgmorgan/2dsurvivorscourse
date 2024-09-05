extends CanvasLayer

@export var arena_time_manager : Node

@onready var label_node = %Label

func _process(_delta):
	if arena_time_manager == null:
		return
	
	var time_elapsed = arena_time_manager.get_time_elapsed()
	
	label_node.text = format_seconds_as_string(time_elapsed)

func format_seconds_as_string(seconds: float):
	var int_seconds = int(seconds)
	@warning_ignore("integer_division")
	return (str(int_seconds / 60) + ":" + ("%02d" % (int_seconds % 60)))
