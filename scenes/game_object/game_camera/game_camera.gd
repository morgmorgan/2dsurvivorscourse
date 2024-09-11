extends Camera2D

var target_position = Vector2.ZERO

func _ready():
	make_current()

func _process(_delta):
	acquire_target()

func acquire_target():
	var player : Node2D = get_tree().get_first_node_in_group("player")
	if player != null:
		global_position = player.global_position
