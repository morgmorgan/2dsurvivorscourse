extends AudioStreamPlayer

func _ready():
	# Check if parent is button
	var parent_node = get_parent()
	
	if parent_node == null:
		return
		
	parent_node.connect("pressed", on_pressed)
	
func on_pressed():
	play()
