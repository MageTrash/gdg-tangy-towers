extends Label

onready var time_passed = 0.00

func _ready() -> void:
	Global.connect("game_end", self, "on_game_end")

func _process(delta):
	time_passed += delta
	var time = stepify(time_passed, 0.1)
	var mils = fmod(time, 1) * 10
	var secs = fmod(time, 60)
	var mins = fmod(time, 60*60) / 60
	var time_string = "%02d:%02d.%01d" % [mins, secs, mils]
	text = time_string


func on_game_end() -> void:
	Global.time_passed = time_passed
