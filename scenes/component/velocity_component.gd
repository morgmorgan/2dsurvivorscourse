extends Node
class_name VelocityComponent

@export var max_speed : int = 40
@export var acceleration : float = 5

var velocity = Vector2.ZERO
	
func accelerate_to_player():
	var owner_node : Node2D = owner
	if owner_node == null:
		return
	
	var player : Node2D = get_tree().get_first_node_in_group("player")
	if player == null:
		return
		
	var direction = (player.global_position - owner_node.global_position).normalized()
	
	accelerate_in_direction(direction)

func move(character_body : CharacterBody2D):
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity

func accelerate_in_direction(direction : Vector2):
	var target_velocity = direction * max_speed
	velocity = velocity.lerp(target_velocity, 1 - exp(-acceleration * get_process_delta_time()))

func decelerate():
	accelerate_in_direction(Vector2.ZERO)
