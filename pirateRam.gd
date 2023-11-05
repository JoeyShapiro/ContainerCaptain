extends CharacterBody2D

@export var path_to_player = '../Player'
var player
@export var ram_cooldown = 1
var ram_timer
@export var speed = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(path_to_player) # seems bad, but eh
	ram_timer = 0.001 # TODO so the first hit counts

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var r = get_angle_to(player.position)
	
	rotation += r
	
	# TODO dont waste time on math
	velocity = Vector2(cos(rotation), sin(rotation)) * speed
	if ram_timer > 0:
		ram_timer -= delta
		#ram_timer = max(ram_timer, 0)
		velocity = Vector2.ZERO
	
	position += velocity
	rotation += PI/2 # or could minus from everywhere
	
func _physics_process(delta):
	var collision_body = move_and_collide(velocity * delta)
	if collision_body:
		if ram_timer <= 0 and collision_body.get_collider().has_method("on_hit"):
			collision_body.get_collider().on_hit(1)
			position -= velocity * speed * 15
		ram_timer = ram_cooldown
