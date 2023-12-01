extends CharacterBody2D

@export var path_to_player = '../Player'
@export var bullet_scene : PackedScene
var player

@export var speed = 1
@export var max_hull = 10
@export var damage = 5
@export var cost = 5
var hull

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(path_to_player) # seems bad, but eh
	hull = max_hull
	$TimerShoot.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hull <= 0:
		on_destroy()
	
func _physics_process(delta):
	var collision_body = move_and_collide(velocity * delta)

func on_hit(damage):
	pass

func on_destroy():
	queue_free()

func _on_timer_shoot_timeout():
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
		
		var bullet = bullet_scene.instantiate()
		bullet.position = position
		# dont care about rotation
		bullet.direction = Vector2(cos(r), sin(r))
		bullet.speed = 4
		bullet.damage = damage
		
		get_node('../').add_child(bullet)
