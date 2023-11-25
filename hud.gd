extends CanvasLayer

signal scale_down
signal scale_up

# list of packed scenes

# seems best most pratical way
# menu items call parent with item
# use functions
# parent emits
# hud emits
# main catches

# x each menu item has an emit caught by parent/main
# cant be dynamic

# x menu items call root function
# bad practice

# x everyone keeps emitting and pass it up
# to much flow control
# either way items store and send scene

# drones stop moving if no pay

# scale game with scale of window

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func display_stats(health, gold, resources):
	$Stats/LabelHealth.text = '🛟: ' + str(health)
	$Stats/LabelGold.text = '💎: ' + str(gold)
	$Stats/LabelResources.text = '🪵: ' + str(resources)

func _on_scale_down_pressed():
	scale_down.emit()

func _on_scale_up_pressed():
	scale_up.emit()
