extends CharacterBody2D



func _physics_process(delta):
	var collision_body = move_and_collide(velocity * delta)
	if collision_body:
		if collision_body.get_collider().has_method("on_pickup"):
			collision_body.get_collider().on_pickup('resource')
			queue_free()
