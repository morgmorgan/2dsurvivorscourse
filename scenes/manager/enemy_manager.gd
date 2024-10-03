extends Node

const MAX_SPAWN_INTERVAL = 1
const MIN_SPAWN_INTERVAL = 0.1

@export_group("Parameters")
@export var SPAWN_RADIUS = 450
@export var base_spawn_interval : float = 1.0

@export_group("Enemies")
@export var basic_enemy_scene : PackedScene
@export var slime_enemy_scene : PackedScene

@export_group("Components")
@export var arena_time_manager : ArenaTimeManager


@onready var timer_node = $Timer

var enemy_table = WeightedTable.new()

func _ready():
	enemy_table.add_item(basic_enemy_scene, 10)
	
	timer_node.wait_time = base_spawn_interval
	timer_node.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	timer_node.start()
	
func get_spawn_position():
	var player : Node2D = get_tree().get_first_node_in_group("player")
	if player == null:
		return null
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	for increment in 4:
		var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		
		# Raycast
		var query_parameters = PhysicsRayQueryParameters2D.create(
			player.global_position, spawn_position, 1 << 0)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
		# Check for valid
		if result.is_empty():
			return spawn_position
		
		# Rotate random direction vector
		random_direction = random_direction.rotated(deg_to_rad(90))
		
	return null
	
func on_timer_timeout():
	timer_node.start()

	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate()
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if entities_layer == null:
		return
	entities_layer.add_child(enemy)
	
	var spawn_pos = get_spawn_position()
	if spawn_pos != null:
		enemy.global_position = get_spawn_position()

func on_arena_difficulty_increased(arena_difficulty : int):
	# Linearly decrease spawn interval based on game length and max/min interval times
	var number_of_intervals = float(arena_time_manager.game_length_seconds) / float(
		arena_time_manager.DIFFICULTY_INCREASE_INTERVAL) 
	var spawn_factor : float = MAX_SPAWN_INTERVAL / number_of_intervals
	timer_node.wait_time = max(base_spawn_interval - (arena_difficulty * spawn_factor), 0.1) 
	
	if arena_difficulty == 3:
		enemy_table.add_item(slime_enemy_scene, 20)
