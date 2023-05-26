extends KinematicBody2D

export(int) var hp = 100

func die():
	if hp < 0:
		queue_free()

func take_damage(amount: int) -> void:
	self.hp -= amount
	print(name + "damaged:(")
