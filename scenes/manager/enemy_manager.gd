extends Node

@export var SPAWN_RADIUS = 375

@export var basic_enemy_scene : PackedScene

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	
	
func on_timer_timeout():
	var player : Node2D = get_tree().get_first_node_in_group("player")
	if player == null:
		return
		
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	
	var enemy = basic_enemy_scene.instantiate()
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if entities_layer == null:
		return
	entities_layer.add_child(enemy)
	enemy.global_position = spawn_position
