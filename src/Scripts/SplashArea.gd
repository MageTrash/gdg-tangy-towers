extends Area2D

var damage: int
var time: float = 3.0

func _ready() -> void:
	assert(damage != null, "set the splash damage")
	var timer : Timer = Timer.new()
	timer.wait_time = time
	timer.connect("timeout", self, "time_end")
	add_child(timer)
	timer.start()

func time_end() -> void:
	for area in get_overlapping_areas():
		if area.is_in_group("Enemy"):
			area.get_parent().health -= damage
	queue_free()
