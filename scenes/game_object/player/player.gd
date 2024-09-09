extends CharacterBody2D

@onready var damage_interval_timer : Timer = $DamageIntervalTimer

const MAX_SPEED = 125
const ACCELERATION_SMOOTHING = 11

var colliding_bodies : int = 0 

func _ready():
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)


func _process(delta):
	var movement_vector = get_movement_vector().normalized()
	
	var target_velocity = movement_vector * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	
	move_and_slide()

func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)
	
func check_for_damage():
	if colliding_bodies <= 0 || !damage_interval_timer.is_stopped():
		return
	
	$HealthComponent.damage(1)
	damage_interval_timer.start()
	
func on_body_entered(other_body : Node2D):
	colliding_bodies += 1
	check_for_damage()

func on_body_exited(other_body : Node2D):
	colliding_bodies -= 1
	
func on_damage_interval_timer_timeout():
	check_for_damage()
