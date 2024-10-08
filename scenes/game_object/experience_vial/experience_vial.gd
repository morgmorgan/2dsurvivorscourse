extends Node2D

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite_2d = $Sprite2D

func _ready():
	$Area2D.area_entered.connect(on_area_entered)

func on_area_entered(_other : Area2D):
	# Disable collisions
	Callable(disable_collision).call_deferred()
	
	# Disable floating animation
	$AnimationPlayer.current_animation = "RESET"
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite_2d, "scale", Vector2.ZERO, .15).set_delay(.35)
	tween.chain()
	tween.tween_callback(collect)

func collect():
	GameEvents.emit_experience_vial_collected(1)
	queue_free()

func tween_collect(percent : float, start_pos : Vector2):
	var player : Node2D = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	# Set position
	global_position = start_pos.lerp(player.global_position, percent)
	
	# Set rotation
	var direction_from_start = player.global_position - start_pos
	var target_rotation = direction_from_start.angle() - deg_to_rad(90)
	rotation = lerp_angle(rotation, target_rotation, 1-exp(-2 * get_process_delta_time()))

func disable_collision():
	collision_shape_2d.disabled = true
