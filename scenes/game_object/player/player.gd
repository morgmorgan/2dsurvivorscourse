extends CharacterBody2D

@onready var damage_interval_timer : Timer = $DamageIntervalTimer
@onready var health_component : HealthComponent = $HealthComponent
@onready var health_bar : ProgressBar = $HealthBar
@onready var abilities_node : Node = $Abilities
@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var visuals : Node2D = $Visuals

const MAX_SPEED = 125
const ACCELERATION_SMOOTHING = 11

var colliding_bodies : int = 0 

func _ready():
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()


func _process(delta):
	var movement_vector = get_movement_vector().normalized()
	
	var target_velocity = movement_vector * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	
	move_and_slide()
	
	# Play walk animation
	if movement_vector.x != 0 || movement_vector.y != 0:
		anim_player.play("walk")
	else:
		anim_player.play("RESET")
		
	# Face Movement Direction
	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale.x = move_sign

func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)
	
func check_for_damage():
	if colliding_bodies <= 0 || !damage_interval_timer.is_stopped():
		return
	
	health_component.damage(1)
	damage_interval_timer.start()
	
func update_health_display():
	health_bar.value = health_component.get_health_percent()
	
func on_body_entered(_other_body : Node2D):
	colliding_bodies += 1
	check_for_damage()

func on_body_exited(_other_body : Node2D):
	colliding_bodies -= 1
	
func on_damage_interval_timer_timeout():
	check_for_damage()

func on_health_changed():
	health_bar.value = health_component.get_health_percent()
	
func on_ability_upgrade_added(ability_upgrade : AbilityUpgrade, _current_upgrades : Dictionary):
	if not ability_upgrade is Ability:
		return
	
	var ability : Ability = ability_upgrade
	abilities_node.add_child(ability.ability_controller_scene.instantiate())
