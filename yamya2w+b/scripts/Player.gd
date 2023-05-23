extends KinematicBody2D
signal hit

export (PackedScene) var bullet

const ACCELERATION = 250
const max_speed = 60
const FRICTION = 400

var velocity = Vector2.ZERO
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var end_of_gun = $endofgun

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Running/blend_position", input_vector)
		animationState.travel("Running")
		velocity = velocity.move_toward(input_vector * max_speed, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		pass

func shoot():
	var bullet_instance = bullet.instance()
	add_child(bullet_instance)
	bullet_instance.global_position = end_of_gun.global_position
