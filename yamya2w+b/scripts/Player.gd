extends KinematicBody2D

const ACCELERATION = 250
const max_speed = 60
const FRICTION = 400

var velocity = Vector2.ZERO
onready var animationPlayer = $AnimationPlayer
#onready var animationTree = $AnimationTree

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, ACCELERATION * delta)
	else:
		animationPlayer.play("RESET")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	
	velocity = move_and_slide(velocity)
