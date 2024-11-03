extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component : VelocityComponent = $VelocityComponent

func _ready():
	$HurtBoxComponent.hit.connect(on_hit)

func _process(_delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	## Face Movement Direction
	#var move_sign = sign(velocity.x)
	#if move_sign != 0:
		#visuals.scale.x = move_sign

func on_hit():
	$HitSoundEffect.play()
