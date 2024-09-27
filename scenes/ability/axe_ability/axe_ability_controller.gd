extends Node

@export var damage = 10
@export var axe_ability_scene : PackedScene

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	
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
	axe_instance.hitbox_component.damage = damage
