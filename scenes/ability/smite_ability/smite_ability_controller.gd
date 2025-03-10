extends Node

const BASE_RANGE : int = 25
const BASE_DAMAGE : int = 50

const BASE_COOLDOWN : float = 10.0

@export var ability_scene : PackedScene

func _ready():
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	$Timer.wait_time = BASE_COOLDOWN
	$Timer.timeout.connect(on_timer_timeout)
	
func on_ability_upgrade_added(upgrade : AbilityUpgrade, current_upgrades : Dictionary):
	if upgrade.id == "smite_cooldown":
		on_timer_timeout()
		$Timer.wait_time = BASE_COOLDOWN - (1.0 * current_upgrades["smite_cooldown"]["quantity"])
		$Timer.start()

func on_timer_timeout():
	var player : Node2D = get_tree().get_first_node_in_group("player")
	if player == null:
		return null
	
	var direction = Vector2.RIGHT.rotated(randf_range(0,TAU))
	var spawn_position = player.global_position + (direction * randf_range(0, BASE_RANGE))
	
	# Raycast
	var query_parameters = PhysicsRayQueryParameters2D.create(
		player.global_position, spawn_position, 1 << 0)
	var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
	
	if !result.is_empty():
		spawn_position = result["position"]
		
	var smite_instance : SmiteAbility = ability_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(smite_instance)
	smite_instance.global_position = spawn_position
	smite_instance.hitbox_component.damage = BASE_DAMAGE
