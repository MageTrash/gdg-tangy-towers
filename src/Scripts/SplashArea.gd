extends Area2D

var damage: int
var time: float = 3.0

func _ready() -> void:
	assert(damage != null, "set the splash damage")
	yield(get_tree().create_timer(time), "timeout")
	for area in get_overlapping_areas():
		if area.is_in_group("Enemy"):
			area.get_parent().health -= damage
	queue_free()
