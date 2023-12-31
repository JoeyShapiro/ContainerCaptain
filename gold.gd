extends CharacterBody2D

@export var vacuum_modifier = 3

func _physics_process(delta):
	var collision_body = move_and_collide(velocity * delta)
	if collision_body:
		if collision_body.get_collider().has_method("on_pickup"):
			collision_body.get_collider().on_pickup('gold')
			queue_free()
