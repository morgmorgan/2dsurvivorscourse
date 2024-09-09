extends Node
class_name ExperienceManager

signal experience_updated(in_current_experience : float, in_target_experience : float)
signal level_up(new_level : int)

var current_experience : float = 0
var current_level : int = 1
var target_experience = 1

const TARGET_EXPERIENCE_GROWTH = 5

func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)

func on_experience_vial_collected(number : float):
	increment_experience(number)

func increment_experience(number : float):
	current_experience = min(current_experience + number, target_experience)
	
	experience_updated.emit(current_experience, target_experience)
	
	# Level up
	if current_experience == target_experience:
		current_level += 1
		target_experience += TARGET_EXPERIENCE_GROWTH
		current_experience = 0
		experience_updated.emit(current_experience, target_experience)
		level_up.emit(current_level)
