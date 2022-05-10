extends PathFollow2D

export(Vector2) var fungaberry_health = Vector2(4, 7)
export(float) var fungaberry_speed = 30.0
export(Vector2) var rotnana_health = Vector2(8, 15)
export(float) var rotnana_speed = 25.0
export(Vector2) var lemonose_health = Vector2(15, 25)
export(float) var lemonose_speed = 20.0
export(Vector2) var wormy_health = Vector2(30, 40)
export(float) var wormy_speed = 10.0
export(Vector2) var creature_health = Vector2(65, 80)
export(float) var creature_speed = 3.0

export(float) var knockback : float = 200.0

enum enemy {
	FUNGABERRY,
	ROTNANA,
	LEMONOSE,
	WORMY,
	CREATURE
}

# Is chosen from enemy enum
var enemy_type : int

var health : float = 10.0 setget set_health
var path_speed : float
var slow_multiplier : float = 1.0 setget set_slowed
var slow_time : float = 4.0

onready var collider : Area2D = $Collider
onready var anim : AnimationPlayer
onready var slow_timer: Timer = Timer.new()

func _ready() -> void:
	set_loop(false)
	slow_timer.connect("timeout", self, "reset_slowed")
	anim.connect("animation_finished", self, "on_anim_fin")
	collider.connect("body_entered", self, "on_body_entered")
	add_child(slow_timer)

	Global.connect("game_end", self, "on_game_end")

	match enemy_type:
		enemy.FUNGABERRY:
			health = Global.rng.randi_range(fungaberry_health.x, fungaberry_health.y)
			path_speed = fungaberry_speed
		enemy.ROTNANA:
			health = Global.rng.randi_range(rotnana_health.x, rotnana_health.y)
			path_speed = rotnana_speed
		enemy.LEMONOSE:
			health = Global.rng.randi_range(lemonose_health.x, lemonose_health.y)
			path_speed = lemonose_speed
		enemy.WORMY:
			health = Global.rng.randi_range(wormy_health.x, wormy_health.y)
			path_speed = wormy_speed
		enemy.CREATURE:
			health = Global.rng.randi_range(creature_health.x, creature_health.y)
			path_speed = wormy_speed
	health *= Global.enemy_scale_factor

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
	Global.decrement_player_health()
	# made it to the end anim
	on_anim_fin("death")


func set_health(value: float) -> void:
	# if the current health is greater than the new health value
	# then you've lost health and play the hit animation
	if health > value:
		anim.play("hit")
	#else: you should make some sort of health added effect/animation here
	health = value
	if health <= 0:
		anim.play("death")
		Global.enemy_death_count += 1


func on_anim_fin(anim_name: String) -> void:
	if anim_name == "death":
		SfxMan.play_enemydeathsfx()
		anim.get_parent().queue_free()
		queue_free()


func on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		var to_player : Vector2 = (body.global_position - global_position).normalized()
		body.stunned = to_player * knockback * (Global.player_speed_mod*0.85)
		path_speed *= 0.85


func on_game_end() -> void:
	path_speed = 0.0
