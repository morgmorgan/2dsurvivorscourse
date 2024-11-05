extends Node
class_name ArenaTimeManager

const DIFFICULTY_INCREASE_INTERVAL = 5

@export var game_length_seconds : int = 60

@export var end_screen_scene : PackedScene

@onready var timer_node = $Timer

signal arena_difficulty_increased(arena_difficulty : int)

var arena_difficulty : int = 0

func _ready():
	timer_node.wait_time = game_length_seconds + 1
	timer_node.timeout.connect(on_timer_timeout)
	timer_node.start()
	
func _process(delta):
	var next_time_target = timer_node.wait_time - ((
		arena_difficulty + 1) * DIFFICULTY_INCREASE_INTERVAL
	)
	
	if timer_node.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)

func get_time_elapsed():
	return timer_node.wait_time - timer_node.time_left

func on_timer_timeout():
	var end_screen_instance = end_screen_scene.instantiate()
	if end_screen_instance == null:
		return
	add_child(end_screen_instance)
	end_screen_instance.play_jingle()
