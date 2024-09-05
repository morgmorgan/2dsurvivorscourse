extends Camera2D

var target_position = Vector2.ZERO


func _ready():
	make_current()


func _process(delta):
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 10))


func acquire_target():
	var player : Node2D = get_tree().get_first_node_in_group("player")
	if player != null:
		#var player : CharacterBody2D = player_nodes[0]
		#target_position = player.global_position
		target_position = player.global_position
