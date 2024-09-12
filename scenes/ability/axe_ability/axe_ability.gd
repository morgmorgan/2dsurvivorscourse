extends Node2D

const MAX_RADIUS = 100


func _ready():
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, 2.0, 5)
	tween.tween_callback(queue_free)
	
func tween_method(rotations : float):
	var current_radius = (rotations / 2) * MAX_RADIUS
	var current_direction = Vector2.RIGHT.rotated(rotations * TAU)
	
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	global_position = player.global_position + (current_direction * current_radius)
