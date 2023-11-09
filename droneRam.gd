extends CharacterBody2D

@export var path_to_player = '../Player'
var player

@export var ram_cooldown = 1
var ram_timer
@export var speed = 2
@export var max_hull = 10
@export var damage = 5
var hull

@export var resource_scene : PackedScene
@export var gold_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(path_to_player) # seems bad, but eh
	ram_timer = 0.001 # TODO so the first hit counts
	hull = max_hull

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hull <= 0:
		on_destroy()
	
	var enemies = get_tree().get_nodes_in_group('enemy')
	
	# find the nearest enemy
	var nearest_enemy = null # dont need to solve this now
	var nearest_mag = INF # so i dont have to do it everytime
	for enemy in enemies:
		var e_mag = position.distance_to(enemy.position)
		if e_mag < nearest_mag:
			nearest_enemy = enemy
			nearest_mag = e_mag
	
	# better than len(enemies)
	if nearest_enemy:
		var r = get_angle_to(enemies[0].position)
		rotation += r
	
		# TODO dont waste time on math
		velocity = Vector2(cos(rotation), sin(rotation)) * speed
		if ram_timer > 0:
			ram_timer -= delta
			velocity = Vector2.ZERO
	
		position += velocity
		rotation += PI/2 # or could minus from everywhere
	
func _physics_process(delta):
	var collision_body = move_and_collide(velocity * delta)
	if collision_body:
		if ram_timer <= 0 and collision_body.get_collider().has_method("on_hit"):
			collision_body.get_collider().on_hit(damage)
			position -= velocity * speed * 15
		ram_timer = ram_cooldown

func on_hit(damage):
	pass

func on_destroy():
	queue_free()
