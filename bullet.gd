extends CharacterBody2D

@export var speed = 4
@export var direction = Vector2.ZERO
@export var damage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func _physics_process(delta):
	var collision_body = move_and_collide(velocity * delta)
	if collision_body:
		if collision_body.get_collider().has_method("on_hit"):
			collision_body.get_collider().on_hit(damage)
			position -= velocity * speed * 15
		queue_free()
