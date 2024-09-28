extends CharacterBody2D

const MAX_SPEED = 40

@onready var health_component : HealthComponent = $HealthComponent
@onready var visuals = $Visuals


func _process(_delta):
	var direction = get_direction_to_player()
	velocity = direction * MAX_SPEED
	move_and_slide()
	
	# Face Movement Direction
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale.x = move_sign


func get_direction_to_player():
	var player : Node2D = get_tree().get_first_node_in_group("player")
	if player != null:
		return (player.global_position - global_position).normalized()
	return Vector2.ZERO
