extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component : VelocityComponent = $VelocityComponent

var is_moving : bool = false

func _ready():
	$HurtBoxComponent.hit.connect(on_hit)

func _process(_delta):
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
	velocity_component.move(self)

	# Face Movement Direction
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale.x = move_sign

func set_is_moving(moving : bool):
	is_moving = moving
	
func on_hit():
	$HitSoundEffect.play()
