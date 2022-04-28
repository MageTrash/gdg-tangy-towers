extends Label

var time = 120

func _process(delta):
	time -= delta
	var time_display = stepify(time, 0.1)
	text = var2str(time_display)
