extends KinematicBody2D
#signal hit

#export (PackedScene) var bullet

const ACCELERATION = 250
const max_speed = 60
const FRICTION = 400

enum {
	MOVE,
	ATTACK,
	ATTACK2,
	DODGE,
}

export(int) var hp = 100

var velocity = Vector2.ZERO


onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
#onready var end_of_gun = $endofgun
var state = MOVE

func _ready():
	animationTree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ATTACK2:
			attack_state2(delta)
		DODGE:
			dodge_state(delta)

func die():
	if hp < 0:
		queue_free()

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Running/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Attack2/blend_position", input_vector)
		animationState.travel("Running")
		velocity = velocity.move_toward(input_vector * max_speed, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("shoot"):
		state = ATTACK 
	if Input.is_action_just_pressed("shoot2"):
		state = ATTACK2

func attack_state(delta):
	animationState.travel("Attack")

func attack_state2(delta):
	animationState.travel("Attack2")

func attack_animation_finished():
	state = MOVE
func dodge_state(delta):
	pass


#func _unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed("shoot"):
#		pass

#func shoot(): 
#	var bullet_instance = bullet.instance()
#	add_child(bullet_instance)
#	bullet_instance.global_position = end_of_gun.global_position

#fuck this stupid game
func take_damage(amount: int) -> void:
	self.hp -= amount
	print(name + "damaged:(")


#func _on_Hurtbox_body_entered(Hitbox: Node) -> void:
#    var hitbox = Hitbox
#    var base_damage = int(Hitbox.damage)
#    self.hp -= base_damage
#    var name = get_parent().name
#    print(hitbox.get_parent().name + " touched " + name)


#func _on_Hurtbox_body_entered(bhitbox:
#	var base_damage = int(hitbox.damage)
#	self.hp - base_damage
#	print(hitbox.get_parent().name + "touched " + name)


func _on_Hurtbox_area_entered(Hitbox: Node) -> void:
	var hitbox = Hitbox
	var base_damage = int(Hitbox.damage)
	self.hp -= base_damage
	var name = get_parent().name
	print(hitbox.get_parent().name + " touched " + name)
