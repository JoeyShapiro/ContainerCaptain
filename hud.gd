extends CanvasLayer

signal scale_down(drone_scene)
signal scale_up(drone_scene)

# this is fine for now, but should be dynamic from main
# can still use it here
@export var drone_scenes : Array[PackedScene]

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
	var scale_context_scene = preload('res://scaleContext.tscn')
	for drone_scene in drone_scenes:
		var scale_context = scale_context_scene.instantiate()
		scale_context.drone_scene = drone_scene
		scale_context.drone_type = 'ram'
		$Units.add_child(scale_context)
	print($Units.get_child_count())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func display_stats(health, gold, resources):
	$Stats/LabelHealth.text = '🛟: ' + str(health)
	$Stats/LabelGold.text = '💎: ' + str(gold)
	$Stats/LabelResources.text = '🪵: ' + str(resources)

func on_scale_down(drone_scene):
	scale_down.emit(drone_scene)

func on_scale_up(drone_scene):
	scale_up.emit(drone_scene)
