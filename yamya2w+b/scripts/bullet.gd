extends Area2D

export var speed = 200

var velocity = Vector2.ZERO

func _physics_process(delta):
	position += velocity * delta
	$AnimationPlayer.play("fireball")

func set_direction(direction: Vector2):
	velocity = direction.normalized() * speed

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
