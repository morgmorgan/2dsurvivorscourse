extends CanvasLayer

@export var experience_manager : ExperienceManager
@onready var progress_bar : ProgressBar = $MarginContainer/ProgressBar

var target_percent : float = 0

func _ready():
	progress_bar.value = 0
	experience_manager.experience_updated.connect(on_experience_updated)
	
func _process(delta):
	progress_bar.value = snappedf(lerpf(progress_bar.value, target_percent, delta * 2), progress_bar.step)

func on_experience_updated(current_experience : float, target_experience : float):
	if target_experience == 0:
		return
	
	var percent = current_experience / target_experience
	target_percent = percent
