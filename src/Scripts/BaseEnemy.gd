extends PathFollow2D

export(int) var health: int = 10
export(int) var path_speed: int = 30

var is_slowed: bool = false setget set_slowed
var slow_multiplier: float = 1.0

onready var hitbox: Area2D = $HitBox

func _ready() -> void:
	set_loop(false)


func set_slowed(value: bool) -> void:
	if value == false:
		return
	is_slowed = value
	slow_multiplier = 0.75
	yield(get_tree().create_timer(4), "timeout")
	slow_multiplier = 1.0
	is_slowed = false


func _physics_process(delta: float) -> void:
	offset += path_speed * delta * slow_multiplier

	# if the enemy is at the end of the path call reach_end() note: loop must be off for this to work
	if unit_offset >= 1.0:
		reached_end()


# called when enemy has reached the end of path2D
func reached_end() -> void:
	Global.increment_enemies_counter()
	# death anim
	queue_free()


