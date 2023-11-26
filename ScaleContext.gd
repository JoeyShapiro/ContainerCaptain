extends HBoxContainer

# could give this a packed scene, but this is fine for now
# no diff between scene and string
@export var drone_scene = ''
@export var drone_type = ''
@export var drone_rent = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$LabelInfo.text = drone_type + ' (' + str(drone_rent) + ')'

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# should emit or something
func _on_scale_down_pressed():
	get_node('../../').on_scale_down(drone_scene)

func _on_scale_up_pressed():
	get_node('../../').on_scale_up(drone_scene)
