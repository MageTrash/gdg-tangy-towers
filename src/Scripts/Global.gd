extends Node
# This is a global script, it is not attached to anything and can be accessed from any script

# emit this signal with the count array every time it's changed
signal count_change(count_array)
signal tower_rate_change(tower_fire_rate_mod)
signal toggle_player_light(light_change)
signal tower_count_change(tower_count)
signal game_end
signal health_change(player_health)

# this list will change later
enum fruit {
	SPIRALINES,
	FLASHFRUIT,
	POMEYES,
	BULBFRUIT,
	NEUTRAROOTS,
}

# this must be the same length as fruit enum and is ordered the same way
# e.g. the first value in probability corresponds to SPIRALINES

var fruit_probability = [2, 3, 3, 2, 4]
var enemy_probability = [15, 7, 6, 3, 1]
var effect_time = [5.0, 5.0, 7.5, 5.0, 2.5]
var effect_type = 0

var enemy_scale_factor : float = 1.0
var tower_count : int = 0 setget set_tower_count

# these change must return to 1.0
var enemy_speed_mod : float = 1.0
var player_speed_mod : float = 1.0
var tower_damage_mod : float = 1.0
# should only be either -1.0 or 1.0
var player_direction_mod : float = 1.0

var in_effect : bool = false
var neutra_type : int = 0
var shader_type : int = 0

var score : float = 0.0

onready var player_max_health : int = 20
onready var player_health : int = player_max_health
onready var player : KinematicBody2D
onready var map_path : Path2D
onready var enemy_ysort : YSort
onready var wave_timer : Timer = Timer.new()
onready var effect_timer : Timer = Timer.new()
onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()
onready var blindness : CanvasModulate = CanvasModulate.new()
onready var enemy : PackedScene = preload("res://Scenes/Objects/BaseEnemy.tscn")
onready var game_end : bool = false
onready var start_wave_time : float = 5.0
onready var time_passed : float

# This array will hold the counter for each fruit
onready var fruit_counter = [] setget set_fruit_counter
onready var enemy_death_count : int = 0

# for UI
signal new_fruit(fruit)
signal cleanse_effects()

func set_fruit_counter(value) -> void:
	fruit_counter = value
	emit_signal("count_change", fruit_counter)


func _ready() -> void:
	assert(fruit_probability.size() == fruit.size(), "match probability with fruit enum")
	assert(effect_time.size() == fruit.size(), "fill in effect time for each fruit in the enum")

	rng.randomize()
	add_child(blindness)

	reset_fruit_counter()
	tower_count = 0

	effect_timer.connect("timeout", self, "cleanse_effects")
	add_child(effect_timer)

	wave_timer.wait_time = start_wave_time
	wave_timer.connect("timeout", self, "spawn_enemy")
	add_child(wave_timer)


func reset_fruit_counter() -> void:
	fruit_counter.clear()
	# This will add/set all the counters to zero at the start of the game
	for i in len(fruit.values()):
		fruit_counter.append(0)


# Call this function to increment certain fruit counts
func increment_fruit(fruit_type: int) -> void:
	play_effect(fruit_type)
	fruit_counter[fruit_type] += 1
	emit_signal("count_change", fruit_counter)
	emit_signal("new_fruit", fruit_type)


func decrement_player_health(amount: int = 1) -> void:
	player_health -= amount
	emit_signal("health_change", player_health)
	if player_health <= 0:
		emit_signal("game_end")
		score = time_passed * 10 + enemy_death_count * 50
		game_end = true
		get_tree().change_scene_to(load("res://Scenes/UI/TitleScreen.tscn"))


# The map script will register it's path so all towers have a global reference to it
func register_path_and_ysort(path: Path2D, ysort: YSort) -> void:
	map_path = path
	enemy_ysort = ysort


func register_player(body: KinematicBody2D) -> void:
	player = body


# this will pretty much get the tangent of the path2D curve at the offset location
func get_path_tangent(point_offset: float) -> Vector2:
	var point1: Vector2 = map_path.curve.interpolate_baked(point_offset)
	var point2: Vector2 = map_path.curve.interpolate_baked(point_offset + 0.0001)
	return (point2 - point1).normalized()


func spawn_enemy() -> void:
	if game_end: return
	var type_of_enemy = pick_random(enemy_probability)
	var bad_guy = enemy.instance()
	var sprites = bad_guy.get_node("Sprites")
	sprites.get_node("AnimatedSprite").animation = bad_guy.enemy.keys()[type_of_enemy].to_lower()
	bad_guy.enemy_type = type_of_enemy
	bad_guy.remove_child(sprites)
	enemy_ysort.add_child(sprites)
	sprites.set_owner(enemy_ysort)
	bad_guy.get_node("TransformSprites").remote_path = sprites.get_path()
	bad_guy.anim = sprites.get_node("AnimationPlayer")
	map_path.add_child(bad_guy)
	wave_timer.start()
	if wave_timer.wait_time > 1.0:
		wave_timer.wait_time -= 0.02
	if wave_timer.wait_time <= 1.0:
		enemy_scale_factor += 0.01
	if enemy_probability[0] > 5:
		enemy_probability[0] -= 0.25

func pick_random(number_list: Array) -> int:
	var sum : int = 0
	for value in number_list:
		sum += value
	var rand_num : int = Global.rng.randi() % sum
	var index : int = 0
	for value in number_list:
		if rand_num < value:
			break
		else:
			rand_num -= value
			index += 1
	return index


func cleanse_effects() -> void:
	in_effect = false
	effect_timer.stop()
	player_direction_mod = 1.0
	enemy_speed_mod = 1.0
	player_speed_mod = 1.0
	tower_damage_mod = 1.0
	emit_signal("tower_rate_change", 1.0)
	blindness.color = Color.white
	shader_type = 0
	emit_signal("toggle_player_light", false)
	emit_signal("cleanse_effects")


func setup_effect_timer(time: float) -> void:
	# if you already have an effect purify all
	if in_effect:
		cleanse_effects()
	# always do this
	effect_timer.wait_time = time
	in_effect = true
	effect_timer.start()


func play_effect(fruit_type: int) -> void:
	match fruit_type:
		fruit.SPIRALINES:
			setup_effect_timer(effect_time[fruit.SPIRALINES])
			player_direction_mod = -0.9
			enemy_speed_mod = -0.7
			shader_type = 5

		fruit.FLASHFRUIT:
			setup_effect_timer(effect_time[fruit.FLASHFRUIT])
			player_speed_mod = 1.75
			emit_signal("tower_rate_change", 1.75)
			shader_type = 3

		fruit.POMEYES:
			setup_effect_timer(effect_time[fruit.POMEYES])
			emit_signal("toggle_player_light", true)
			blindness.color = Color.black
			tower_damage_mod = 1.5
			shader_type = 1

		fruit.BULBFRUIT:
			setup_effect_timer(effect_time[fruit.BULBFRUIT])
			enemy_speed_mod = 1.75
			shader_type = 4
			for child in map_path.get_children():
				child.health += 10

		fruit.NEUTRAROOTS:
			setup_effect_timer(effect_time[fruit.NEUTRAROOTS])
			neutra_type = Global.rng.randi_range(0, 3)
			shader_type = 2
			#match neutra_type:
				#0:
			enemy_speed_mod = Global.rng.randf_range(-0.25, 2.0)
				#1:
			player_speed_mod = Global.rng.randf_range(0.5, 2.0)
				#2:
			tower_damage_mod = Global.rng.randf_range(0.3, 2.5)
				#3:
			emit_signal("tower_rate_change", Global.rng.randf_range(0.5, 2.5))


func set_tower_count(value: int) -> void:
	tower_count = value
	emit_signal("tower_count_change", tower_count)

