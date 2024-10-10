extends Node

@export var MAX_RANGE : float = 150
@export var sword_ability : PackedScene

@export var base_damage = 5
var base_wait_time : float
var damage_multiplier : float = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func on_ability_upgrade_added(upgrade : AbilityUpgrade, current_upgrades : Dictionary):
	if upgrade.id == "sword_rate":
		var percent_reduction = current_upgrades["sword_rate"]["quantity"] * 0.1
		$Timer.wait_time = base_wait_time * (1 - percent_reduction)
		$Timer.start()
	elif upgrade.id == "sword_damage":
		damage_multiplier = 1 + (current_upgrades["sword_damage"]["quantity"] * 0.15)

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
	
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer") 
	if foreground_layer == null:
		return
	foreground_layer.add_child(sword_instance)
	
	sword_instance.hitbox_component.damage = base_damage * damage_multiplier
	sword_instance.global_position = target_enemy.global_position
	
	# Add random offset
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	# Angle towards enemy
	var enemy_direction = target_enemy.global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()
