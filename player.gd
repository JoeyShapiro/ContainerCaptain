extends CharacterBody2D
signal hit
signal stat_change
signal destroy

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var max_hull = 100
@export var max_gold = 100 # energy
@export var resources = 0 # TODO should i swap these or something
@export var bullet_scene : PackedScene
# TODO i guess it can go here
@export var damnum_scene : PackedScene

@export var sfx_collect_gold : AudioStream
@export var sfx_collect_res : AudioStream
@export var sfx_pay_rent : AudioStream

var hull
var gold
var damage
var vacuum_range

var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$TimerShoot.start()
	$TimerRent.start()
	
	hull = max_hull
	gold = max_gold
	damage = 10
	vacuum_range = 2

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
	stat_change.emit()
	
	var damnum = damnum_scene.instantiate()
	damnum.set_text(position, damage)
	add_child(damnum)
	
	if hull <= 0:
		destroy.emit()

func start(pos):
	position = pos
	hull = max_hull
	resources = 0
	gold = max_gold
	show()
	$CollisionShape2D.disabled = false

func shoot():
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
		var bullet = bullet_scene.instantiate()
		bullet.position = position
		# Vector2.direction_to -_-
		var r = get_angle_to(enemies[0].position)
		# dont care about rotation
		bullet.direction = Vector2(cos(r), sin(r))
		bullet.speed = 4
		bullet.damage = damage
		
		get_node('../').add_child(bullet)

func _on_timer_shoot_timeout():
	shoot()

func on_pickup(item):
	# TODO make class for pickups
	# ... make always give gold, but not other stuff
	# ... gold has vacuum
	print('collected ', item)
	var amount = 1
	if item == 'resource':
		resources += amount
		$AudioPlayer.stream = sfx_collect_res
		$AudioPlayer.play()
	elif item == 'gold' and gold: # TODO  < max_gold:
		amount = randi_range(1, 10)
		gold += amount
		$AudioPlayer.stream = sfx_collect_gold
		$AudioPlayer.play()
	stat_change.emit()
	
	var damnum = damnum_scene.instantiate()
	damnum.set_text(position, amount)
	add_child(damnum)

# do it this way is cheaper (one timer) and makes sense (pay all at once)
# maybe be in them, so each goes down correctly
# nah
func _on_timer_rent_timeout():
	var drones = get_tree().get_nodes_in_group('drone')
	for drone in drones:
		if gold - drone.cost > 0:
			gold -= drone.cost
			stat_change.emit()
			
			var damnum = damnum_scene.instantiate()
			damnum.set_text(drone.position, -drone.cost)
			add_child(damnum)
		else:
			drone.on_destroy()
	# TODO should emit with cost
