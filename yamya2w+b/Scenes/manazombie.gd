extends KinematicBody2D

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		queue_free()
