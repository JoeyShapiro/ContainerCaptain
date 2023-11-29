extends CanvasLayer

signal scale_down(drone_type)
signal scale_up(drone_type)

# this is fine for now, but should be dynamic from main
# can still use it here
@export var drone_options : Array[Dictionary]
var selected_option
var timer
@export var sound_select : AudioStream
@export var sound_scale_up : AudioStream
@export var sound_scale_down: AudioStream

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
	selected_option = 0
	timer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# close enough
	timer += delta
	$Stats/LabelTimer.text = '⏰: ' + str(snapped(timer, 1))
	
	if Input.is_action_just_pressed("menu_up"):
		$Units.get_child(selected_option).toggle()
		selected_option -= 1
		if selected_option > len(drone_options)-1:
			selected_option = 0
		if selected_option < 0:
			selected_option = len(drone_options)-1
		$HudAudio.stream = sound_select
		$HudAudio.play()
		$Units.get_child(selected_option).toggle()
	if Input.is_action_just_pressed("menu_down"):
		$Units.get_child(selected_option).toggle()
		selected_option += 1
		# TODO might be euclid or something
		# just need to work it out
		if selected_option > len(drone_options)-1:
			selected_option = 0
		if selected_option < 0:
			selected_option = len(drone_options)-1
		$HudAudio.stream = sound_select
		$HudAudio.play()
		$Units.get_child(selected_option).toggle()
	if Input.is_action_just_pressed("menu_scale_down"):
		$Units.get_child(selected_option)._on_scale_down_pressed()
		$HudAudio.stream = sound_scale_down
		$HudAudio.play()
	if Input.is_action_just_pressed("menu_scale_up"):
		$Units.get_child(selected_option)._on_scale_up_pressed()
		$HudAudio.stream = sound_scale_up
		$HudAudio.play()

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
	
	selected_option = 0
	$Units.get_child(selected_option).toggle()

func update_difficulty(difficulty):
	$Stats/LabelDifficulty.text = '😈: ' + str(difficulty)

func on_scale_down(drone_option):
	scale_down.emit(drone_option)

func on_scale_up(drone_option):
	scale_up.emit(drone_option)
