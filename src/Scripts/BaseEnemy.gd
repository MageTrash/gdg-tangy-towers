extends PathFollow2D

export(int) var health: int = 10
export(int) var path_speed: int = 30

onready var hitbox: Area2D = $HitBox


func _ready() -> void:
	set_loop(false)


func _physics_process(delta: float) -> void:
	offset += path_speed * delta

	# if the enemy is at the end of the path call reach_end() note: loop must be off for this to work
	if unit_offset >= 1.0:
		reached_end()


# called when enemy has reached the end of path2D
func reached_end() -> void:
	queue_free()


