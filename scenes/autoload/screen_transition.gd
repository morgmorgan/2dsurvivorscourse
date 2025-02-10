extends CanvasLayer

signal transitioned_halfway

var forwards : bool = true

func transition():
	forwards = true
	$AnimationPlayer.play("default")
	await transitioned_halfway
	forwards = false
	$AnimationPlayer.play_backwards("default")
	
func emit_transitioned_halfway():
	if forwards:
		transitioned_halfway.emit()
