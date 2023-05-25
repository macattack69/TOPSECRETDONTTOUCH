extends KinematicBody2D

export(int) var hp = 100

func die():
	if hp < 0:
		queue_free()

func _on_Hurtbox_area_entered(hitbox):
	var base_damage = hitbox.damage
	self.hp -= base_damage
	print(hitbox.get_parent().name + "touched " + name)
