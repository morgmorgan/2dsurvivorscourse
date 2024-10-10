extends Area2D
class_name HurtboxComponent

@export var health_component : HealthComponent
@export var floating_text_scene : PackedScene

func _ready():
	area_entered.connect(on_area_entered)
	
func on_area_entered(other : Area2D):
	if not other is HitboxComponent:
		return
	
	if health_component == null:
		return
		
	var hitbox_component : HitboxComponent = other
	health_component.damage(hitbox_component.damage)
	
	var floating_text : FloatingText = floating_text_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	
	floating_text.global_position = global_position + (Vector2.UP * 16)
	
	var format_string = "%0.1f"
	if round(hitbox_component.damage) == hitbox_component.damage:
		format_string = "%0.0f"
	floating_text.start(format_string % hitbox_component.damage)
