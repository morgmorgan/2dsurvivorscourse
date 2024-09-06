extends Node

@export var MAX_RANGE : float = 150
@export var sword_ability : PackedScene
@export var damage = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	var player : Node2D = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(
			player.global_position) < pow(MAX_RANGE, 2)
	)
	if enemies.size() == 0:
		return
		
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		return a.global_position.distance_squared_to(player.global_position) < (
			b.global_position.distance_squared_to(player.global_position)
		)
	)
	
	var target_enemy = enemies[0]
	
	var sword_instance : SwordAbility = sword_ability.instantiate() 
	player.get_parent().add_child(sword_instance)
	sword_instance.hitbox_component.damage = damage
	sword_instance.global_position = target_enemy.global_position
	
	# Add random offset
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	# Angle towards enemy
	var enemy_direction = target_enemy.global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()
