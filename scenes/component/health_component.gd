extends Node
class_name HealthComponent

signal died

@export var max_health : float = 10

var current_health : float

func _ready():
	current_health = max_health

func damage(in_damage : float):
	current_health = max(current_health - in_damage, 0)
	Callable(check_death).call_deferred()

func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()
