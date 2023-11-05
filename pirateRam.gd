extends CharacterBody2D

@export var path_to_player = '../Player'
var player
@export var ram_cooldown = 1
var ram_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(path_to_player) # seems bad, but eh
	ram_timer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var r = get_angle_to(player.position)
	
	rotation += r
	
	velocity = Vector2(cos(rotation), sin(rotation))
	if ram_timer > 0:
		ram_timer -= delta
		velocity = Vector2.ZERO
	
	position += velocity
	rotation += PI/2 # or could minus from everywhere
	
func _physics_process(delta):
	var collision_body = move_and_collide(velocity * delta)
	if collision_body:
		ram_timer = ram_cooldown