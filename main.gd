extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()

func new_game():
	score = 0
	$Player.start($PlayerStartPos.position)
	#$StartTimer.start()
	$TimerMob.start()
	
	$Hud.display_stats($Player.hull, $Player.gold, $Player.resources)

func _on_timer_mob_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	if len(get_tree().get_nodes_in_group('enemy')):
		return

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

func _on_timer_start_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_player_hit():
	$Hud.display_stats($Player.hull, $Player.gold, $Player.resources)
