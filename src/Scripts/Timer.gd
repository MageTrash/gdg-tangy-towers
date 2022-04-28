extends Label

export(float, 0.0, 120.0) var time = 120.0

func _process(delta):
	time -= delta
	var time_display = stepify(time, 0.1)
	text = var2str(time_display)
