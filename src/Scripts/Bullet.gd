extends Area2D

var speed: int
var damage: int = 1

func _ready() -> void:
	assert(speed != null, "set the bullet speed")
	# When bullet goes off screen it deletes itself
	$VisibilityNotifier2D.connect("screen_exited", self, "queue_free")
	connect("area_entered", self, "hit")


func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta


func hit(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		area.get_parent().health -= damage
		queue_free()
