extends Node
# This is a global script, it is not attached to anything and can be accessed from any script

# emit this signal with the count array every time it's changed
signal count_change(count_array)
signal tower_rate_change(tower_fire_rate_mod)
signal toggle_player_light(light_change)

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
var probability = [1, 1, 1, 1, 1]
var effect_time = [4.5, 10.0, 10.0, 3.0, 3.0]
var effect_type = 0

# these change must return to 1.0
var enemy_speed_mod : float = 1.0
var player_speed_mod : float = 1.0
var tower_damage_mod : float = 1.0
# should only be either -1.0 or 1.0
var player_direction_mod : float = 1.0

var in_effect : bool = false

onready var player : KinematicBody2D
onready var map_path : Path2D
onready var enemy_ysort : YSort
onready var wave_timer : Timer = Timer.new()
onready var effect_timer : Timer = Timer.new()
onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()
onready var blindness : CanvasModulate = CanvasModulate.new()
onready var enemy : PackedScene = preload("res://Scenes/Objects/BaseEnemy.tscn")

onready var enemies_at_end : int = 0
# This boolean will state if fruit collect goes to the counter or active effect
onready var in_wave : bool = true
# This array will hold the counter for each fruit
onready var fruit_counter = [] setget set_fruit_counter


func set_fruit_counter(value) -> void:
	fruit_counter = value
	emit_signal("count_change", fruit_counter)


func _ready() -> void:
	assert(probability.size() == fruit.size(), "match probability with fruit enum")
	assert(effect_time.size() == fruit.size(), "fill in effect time for each fruit in the enum")

	rng.randomize()
	add_child(blindness)

	# This will add/set all the counters to zero at the start of the game
	for i in len(fruit.values()):
		fruit_counter.append(0)

	effect_timer.connect("timeout", self, "cleanse_effects")
	add_child(effect_timer)

	wave_timer.wait_time = 1
	wave_timer.connect("timeout", self, "spawn_enemy")
	wave_timer.autostart = true
	add_child(wave_timer)


# Call this function to increment certain fruit counts
func increment_fruit(fruit_type: int) -> void:
	if in_wave:
		play_effect(fruit_type)
	else:
		fruit_counter[fruit_type] += 1
		emit_signal("count_change", fruit_counter)


func increment_enemies_counter() -> void:
	enemies_at_end += 1


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
	var type_of_enemy = 0
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


func cleanse_effects() -> void:
	in_effect = false
	effect_timer.stop()
	player_direction_mod = 1.0
	enemy_speed_mod = 1.0
	player_speed_mod = 1.0
	emit_signal("tower_rate_change", 1.0)
	blindness.color = Color.white
	emit_signal("toggle_player_light", false)
	tower_damage_mod = 1.0


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

		fruit.FLASHFRUIT:
			setup_effect_timer(effect_time[fruit.FLASHFRUIT])
			player_speed_mod = 1.75
			emit_signal("tower_rate_change", 1.75)

		fruit.POMEYES:
			setup_effect_timer(effect_time[fruit.POMEYES])
			emit_signal("toggle_player_light", true)
			blindness.color = Color.black
			tower_damage_mod = 1.5

		fruit.BULBFRUIT:
			setup_effect_timer(effect_time[fruit.BULBFRUIT])
			enemy_speed_mod = 1.75
			for child in map_path.get_children():
				child.health += 10


		fruit.NEUTRAROOTS:
			setup_effect_timer(effect_time[fruit.NEUTRAROOTS])
			print("neutraroots")

