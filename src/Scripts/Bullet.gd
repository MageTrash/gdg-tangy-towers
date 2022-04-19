extends Area2D

var speed: int

func _ready() -> void:
	assert(speed != null, "set the bullet speed")
	# When bullet goes off screen it deletes itself
	$VisibilityNotifier2D.connect("screen_exited", self, "queue_free")


func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
