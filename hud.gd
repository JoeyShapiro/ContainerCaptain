extends CanvasLayer

signal scale_down(drone_type)
signal scale_up(drone_type)

# this is fine for now, but should be dynamic from main
# can still use it here
@export var drone_options : Array[Dictionary]

# seems best most pratical way
# menu items call parent with item
# use functions
# parent emits
# hud emits
# main catches

# drones stop moving if no pay

# scale game with scale of window

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("menu_up"):
		pass

func display_stats(health, gold, resources):
	$Stats/LabelHealth.text = '🛟: ' + str(health)
	$Stats/LabelGold.text = '💎: ' + str(gold)
	$Stats/LabelResources.text = '🪵: ' + str(resources)

func update_units(drone_options):
	var scale_context_scene = preload('res://scaleContext.tscn')
	for drone_option in drone_options:
		var scale_context = scale_context_scene.instantiate()
		scale_context.drone = drone_option
		$Units.add_child(scale_context)
	print($Units.get_child_count())

func on_scale_down(drone_option):
	scale_down.emit(drone_option)

func on_scale_up(drone_option):
	scale_up.emit(drone_option)
