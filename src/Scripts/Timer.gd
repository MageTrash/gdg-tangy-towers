extends Label

export(float, 0.00, 120.00) var time = 120.00

func _process(delta):
	time -= delta
	var time_display = stepify(time, 0.1)
	text = var2str(time_display)
