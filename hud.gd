extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func display_stats(health, gold, resources):
	$VBoxContainer/LabelHealth.text = '🛟: ' + str(health)
	$VBoxContainer/LabelGold.text = '💎: ' + str(gold)
	$VBoxContainer/LabelResources.text = '🪵: ' + str(resources)
