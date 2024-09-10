extends Node
class_name HealthComponent

signal died
signal health_changed

@export var max_health : float = 10

var current_health : float

func _ready():
	current_health = max_health

func damage(in_damage : float):
	current_health = max(current_health - in_damage, 0)
	health_changed.emit()
	Callable(check_death).call_deferred()

func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()
		
func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)
