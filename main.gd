extends Node

@export var mob_scene: PackedScene
@export var droneRam_scene : PackedScene
@export var drone_options : Array[Dictionary]

@export var sfx_collect_gold : AudioStream
@export var sfx_collect_res : AudioStream
@export var sfx_pay_rent : AudioStream

var timer
var difficulty_scale
# could reverse it, but just make new value
var difficulty_counter

# TODO
"""
- different drones
- scale game window
- game over
- fix difficulty
- leveling
- progress bars
- fix ui (look half decent)
- clean functions
- validate input and stuff (scaling ui)
- better art
- more sounds -
  - sound when pay
  - bool check if can pay
  - stop moving or soemthing
- damage numbers
  - numbers of rent
"""

# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Menu.visible:
		return
	
	timer += delta
	$Hud.update_timer(timer)

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Menu.show()

func new_game():
	$Menu.hide()
	timer = 0
	difficulty_counter = 0
	difficulty_scale = 0
	$Player.start($PlayerStartPos.position)
	$Difficulty.start()
	$TimerMob.start()
	
	drone_options.append({
		'type': 'ram',
		'rent': 1,
		'scene': 'res://droneRam.tscn'
	})
	drone_options.append({
		'type': 'gaurd',
		'rent': 3,
		'scene': 'res://droneRam.tscn'
	})
	drone_options.append({
		'type': 'shooter',
		'rent': 5,
		'scene': 'res://droneRam.tscn'
	})
	drone_options.append({
		'type': 'taunt',
		'rent': 10,
		'scene': 'res://droneRam.tscn'
	})
	
	$Hud.display_stats($Player.hull, $Player.gold, $Player.resources)
	$Hud.update_difficulty(difficulty_scale)
	$Hud.drone_options = drone_options
	# TODO ugly
	$Hud.update_units(drone_options)

func _on_timer_mob_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	mob.max_hull *= difficulty_scale
	mob.damage *= difficulty_scale
	#if len(get_tree().get_nodes_in_group('enemy')):
	#	return

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("PathMob/MobSpawnLoc")
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	#var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	#direction += randf_range(-PI / 4, PI / 4)
	#mob.rotation = direction

	# Choose the velocity for the mob.
	#var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	#mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_difficulty_timeout():
	difficulty_counter += 1
	difficulty_scale = snapped(1 / (1+3*exp(-(difficulty_counter-3))), 0.01)
	$TimerMob.wait_time = 1 / (difficulty_scale)
	print($TimerMob.wait_time)
	$Hud.update_difficulty(difficulty_scale)

func _on_player_hit():
	$Hud.display_stats($Player.hull, $Player.gold, $Player.resources)

func _on_player_stat_change():
	$Hud.display_stats($Player.hull, $Player.gold, $Player.resources)

func _on_hud_scale_up(drone_option):
	# TODO does this need to be unloaded
	# maybe do a PackedScenes, but this is programmatic
	var drone = load(drone_option['scene']).instantiate()
	drone.position = $Player.position
	add_child(drone)

func _on_hud_scale_down(drone_option):
	var drones = get_tree().get_nodes_in_group('drone')
	drones[0].on_destroy()

func _on_player_destroy():
	game_over()

func _on_menu_new_game():
	new_game()
