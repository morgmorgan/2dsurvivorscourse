extends AudioStreamPlayer

func _ready():
	finished.connect(on_finished)
	$Timer.timeout.connect(on_timer_timeout)
	
func on_finished():
	$Timer.start()
	
func on_timer_timeout():
	play()
	
func bass_only(value : bool):
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Music"), 0, value)
