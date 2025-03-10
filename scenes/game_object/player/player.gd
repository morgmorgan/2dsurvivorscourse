extends CharacterBody2D

@export var arena_time_manager : ArenaTimeManager

@onready var damage_interval_timer : Timer = $DamageIntervalTimer
@onready var health_component : HealthComponent = $HealthComponent
@onready var health_bar : ProgressBar = $HealthBar
@onready var abilities_node : Node = $Abilities
@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var visuals : Node2D = $Visuals
@onready var velocity_component : VelocityComponent = $VelocityComponent

var colliding_bodies : int = 0 
var base_speed : int = 0
var base_health_regen : float = 0

func _ready():
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.damaged.connect(on_damaged)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	arena_time_manager.arena_difficulty_increased.connect(on_difficulty_increased)
	
	base_speed = velocity_component.max_speed
	
	check_meta_upgrades()
	
	update_health_display()
	
func check_meta_upgrades():
	base_health_regen += (float)(MetaProgression.get_upgrade_count("health_regen"))
	
	health_component.max_health += MetaProgression.get_upgrade_count("max_health")
	health_component.heal(100)


func _process(_delta):
	var direction = get_movement_vector().normalized()
	
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	# Play walk animation
	if direction.x != 0 || direction.y != 0:
		anim_player.play("walk")
	else:
		anim_player.play("RESET")
		
	# Face Movement Direction
	var move_sign = sign(direction.x)
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

func on_damaged():
	GameEvents.emit_player_damaged()
	$HitSFX.play(0.5)	
	
func on_ability_upgrade_added(ability_upgrade : AbilityUpgrade, _current_upgrades : Dictionary):
	if ability_upgrade is Ability:
		var ability : Ability = ability_upgrade
		abilities_node.add_child(ability.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + int(\
		base_speed * _current_upgrades["player_speed"]["quantity"] * 0.1)

func on_health_changed():
	health_bar.value = health_component.get_health_percent()

func on_difficulty_increased(_difficulty : int):
	health_component.heal(base_health_regen)
