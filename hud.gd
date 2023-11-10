extends CanvasLayer

signal scale_down
signal scale_up

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
