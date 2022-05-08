extends Label

onready var time = 0.00

func _process(delta):
	time += delta
	var time = stepify(time, 0.1)
	var mils = fmod(time, 1) * 10
	print(mils)
	var secs = fmod(time, 60)
	var mins = fmod(time, 60*60) / 60
	var time_string = "%02d:%02d.%01d" % [mins, secs, mils]
	text = time_string
