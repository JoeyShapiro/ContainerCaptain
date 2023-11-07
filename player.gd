extends CharacterBody2D
signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var hull = 100
@export var gold = 100 # energy
@export var resources = 0 # TODO should i swap these or something
@export var bullet_scene : PackedScene

var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("shoot"):
		shoot()

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func _on_body_entered(body):
	#hide() # Player disappears after being hit.
	hit.emit()
	hull -= 1
	# Must be deferred as we can't change physics properties on a physics callback.
	#$CollisionShape2D.set_deferred("disabled", true)

func on_hit(damage):
	hit.emit()
	hull -= damage

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func shoot():
	var enemies = get_tree().get_nodes_in_group('enemy')
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	var r = get_angle_to(enemies[0].position)
	# dont care about rotation
	bullet.direction = Vector2(cos(r), sin(r))
	bullet.speed = 4
	bullet.damage = 1
	
	get_node('../').add_child(bullet)
