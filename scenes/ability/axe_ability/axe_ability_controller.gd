extends Node

@export var base_damage = 10
@export var axe_ability_scene : PackedScene
var damage_multiplier : float = 1

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
func on_ability_upgrade_added(upgrade : AbilityUpgrade, current_upgrades : Dictionary):
	if upgrade.id == "axe_damage":
		damage_multiplier = 1 + (current_upgrades["axe_damage"]["quantity"] * 0.15)
	
func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
		
	var foreground = get_tree().get_first_node_in_group("foreground_layer")
	if foreground == null:
		return
	
	var axe_instance : AxeAbility = axe_ability_scene.instantiate()
	foreground.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = base_damage * damage_multiplier
