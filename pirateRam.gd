extends RigidBody2D

@export var path_to_player = '../Player'
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(path_to_player) # seems bad, but eh


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var r = get_angle_to(player.position)
	
	rotation += r
	position += Vector2(cos(rotation), sin(rotation))
	rotation += PI/2 # or could minus from everywhere
