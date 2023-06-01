extends KinematicBody2D

# signal hit

# export (PackedScene) var bullet

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500
const DODGE_SPEED = 120
const BULLET_SCENE = preload("res://Scenes/Bullet.tscn")

enum {
	MOVE,
	ATTACK,
	ATTACK2,
	DODGE,
}

export (int) var hp = 100

var velocity = Vector2.ZERO
var dodgeVector = Vector2.DOWN 

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

var state = MOVE

func _ready():
	animationTree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			moveState(delta)
		ATTACK:
			attackState(delta)
		ATTACK2:
			attackState2(delta)
		DODGE:
			dodgeState(delta) 

func die():
	if hp < 0:
		queue_free()

func moveState(delta):
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputVector = inputVector.normalized()

	if inputVector != Vector2.ZERO:
		dodgeVector = inputVector
		animationTree.set("parameters/Idle/blend_position", inputVector)
		animationTree.set("parameters/Running/blend_position", inputVector)
		animationTree.set("parameters/Attack/blend_position", inputVector)
		animationTree.set("parameters/Attack2/blend_position", inputVector)
		animationTree.set("parameters/Dodge/blend_position", inputVector)
		animationState.travel("Running")
		velocity = velocity.move_toward(inputVector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move()

	if Input.is_action_just_pressed("shoot"):
		state = ATTACK 
	if Input.is_action_just_pressed("shoot2"):
		state = ATTACK2
	if Input.is_action_just_pressed("dodge"):
		state = DODGE

func dodgeState(delta):
	velocity = dodgeVector * DODGE_SPEED
	animationState.travel("Dodge")
	move()

func attackState(delta):
	animationState.travel("Attack")
	createBullet()

func createBullet():
	var bulletInstance = BULLET_SCENE.instance()
	add_child(bulletInstance)
	bulletInstance.global_position = global_position
	bulletInstance.set_direction(dodgeVector)
	
func move():
	velocity = move_and_slide(velocity)

func attackState2(delta):
	animationState.travel("Attack2")

func dodge_animation_finished():
	state = MOVE

func attack_animation_finished():
	animationPlayer.play("RESET")
	print("animation reset")
	state = MOVE

func take_damage(amount: int) -> void:
	self.hp -= amount
	print(name + " damaged :(")

func _on_Hurtbox_area_entered(Hitbox: Node) -> void:
	var hitbox = Hitbox
	var baseDamage = int(hitbox.damage)
	self.hp -= baseDamage
	var name = get_parent().name
	print(hitbox.get_parent().name + " touched " + name)
