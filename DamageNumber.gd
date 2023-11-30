extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$TimerToLive.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_text(pos, text):
	var th = 64
	offset = pos+Vector2(randf_range(th, -th), randf_range(th, -th))
	$RichTextLabel.text = str(text)

func _on_timer_to_live_timeout():
	queue_free()
