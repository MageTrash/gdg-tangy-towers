extends PathFollow2D

export(int) var health: int = 10 setget set_health
export(int) var path_speed: int = 30

var slow_multiplier: float = 1.0 setget set_slowed
var slow_time: float = 4.0

onready var hitbox: Area2D = $HitBox
onready var slow_timer: Timer = Timer.new()

func _ready() -> void:
	set_loop(false)
	slow_timer.connect("timeout", self, "reset_slowed")
	add_child(slow_timer)


# this gets called when it's health is changed and the check makes sure you don't get
# overlapping timers counting down to change slow_multiplier back to 1.0
func set_slowed(value: float) -> void:
	if value != slow_multiplier:
		slow_multiplier = value
		slow_timer.wait_time = slow_time
		slow_timer.start()


func reset_slowed() -> void:
	slow_multiplier = 1.0


func _physics_process(delta: float) -> void:
	# offset is it's distance along the path2D; delta makes it sure it moves relative
	# to the  time past instead of framerate: slow_multipler should be from 0 to 1.0 (to slow it down)
	offset += path_speed * delta * slow_multiplier * Global.enemy_speed_mod

	# if the enemy is at the end of the path call reach_end() note: loop must be off for this to work
	if unit_offset >= 1.0:
		reached_end()


# called when enemy has reached the end of path2D
func reached_end() -> void:
	Global.increment_enemies_counter()
	# made it to the end anim
	queue_free()


func set_health(value: int) -> void:
	health = value
	if health <= 0:
		dead()


func dead() -> void:
	# death anim???
	queue_free()

