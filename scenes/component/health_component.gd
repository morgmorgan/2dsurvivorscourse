extends Node
class_name HealthComponent

signal died
signal health_changed
signal damaged

@export var max_health : float = 10
@export var is_crab : bool = false
@export var is_golem : bool = false

var current_health : float

func _ready():
	current_health = max_health
	
	if is_crab:
		current_health = current_health * (1.0 \
		 - (MetaProgression.get_upgrade_count("crab_slayer") * 0.1))
		
	if is_golem:
		current_health = current_health * (1.0 \
		 - (MetaProgression.get_upgrade_count("golem_slayer") * 0.1))

func damage(in_damage : float):	
	if in_damage < 0:
		current_health = min(max_health, current_health - in_damage)
	else:
		current_health = max(current_health - in_damage, 0)
		damaged.emit()
	health_changed.emit()
	Callable(check_death).call_deferred()
	
func heal(in_health : float):
	damage(in_health * -1.0)

func check_death():
	if current_health == 0:
		## Wait so we can see the hit flash
		#await.get_tree().create_timer(0.1).timeout
		died.emit()
		owner.queue_free()
		
func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)
