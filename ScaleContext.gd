extends HBoxContainer

# could give this a packed scene, but this is fine for now
# doesnt need the scene, and cant really use it
@export var drone : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	$LabelInfo.text = drone.type + ' (' + str(drone.rent) + ')'

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# should emit or something
func _on_scale_down_pressed():
	get_node('../../').on_scale_down(drone)

func _on_scale_up_pressed():
	get_node('../../').on_scale_up(drone)
