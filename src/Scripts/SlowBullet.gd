extends Area2D

var speed: int
var slowness: float

func _ready() -> void:
	assert(speed != null, "set the bullet speed")
	assert(slowness != null, "set the bullet slowness effect")
	# When bullet goes off screen it deletes itself
	$VisibilityNotifier2D.connect("screen_exited", self, "queue_free")
	connect("area_entered", self, "hit")


func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta


func hit(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		if area.get_parent().slow_multiplier == 1.0:
			area.get_parent().slow_multiplier = slowness
			queue_free()
