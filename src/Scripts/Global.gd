extends Node
# This is a global script, it is not attached to anything and can be accessed from any script

# emit this signal with the count array every time it's changed
signal count_change(count_array)

# this list will change later
enum fruit {
	SPIRALINES,
	NOIDFRUIT,
	POMEYES,
	THORNFRUIT,
	NEUTRAROOTS,
}

# this must be the same length as fruit enum and is ordered the same way
# e.g. the first value in probability corresponds to SPIRALINES
var probability = [1, 1, 10, 1, 1]
var effect_time = [3.0, 3.0, 10.0, 3.0, 3.0]

var enemy_speed_mod : float = 1.0
var player_speed_mod : float = 1.0
var tower_fire_rate_mod

onready var player : KinematicBody2D
onready var map_path : Path2D
onready var wave_timer : Timer = Timer.new()
onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()
onready var blindness : CanvasModulate = CanvasModulate.new()
onready var enemy : PackedScene = preload("res://Scenes/Objects/BaseEnemy.tscn")

onready var enemies_at_end : int = 0
# This boolean will state if fruit collect goes to the counter or active effect
onready var in_wave : bool = true
# This array will hold the counter for each fruit
onready var fruit_counter = []


func _ready() -> void:
	assert(probability.size() == fruit.size(), "match probability with fruit enum")
	assert(effect_time.size() == fruit.size(), "fill in effect time for each fruit in the enum")

	rng.randomize()
	add_child(blindness)

	# This will add/set all the counters to zero at the start of the game
	for i in len(fruit.values()):
		fruit_counter.append(0)

	wave_timer.wait_time = 2
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
func register_path(path: Path2D) -> void:
	map_path = path


func register_player(body: KinematicBody2D) -> void:
	player = body


func spawn_enemy() -> void:
	Global.map_path.add_child(enemy.instance())
	wave_timer.start()


func play_effect(fruit_type: int) -> void:
	match fruit_type:
		fruit.SPIRALINES:
			print("spiralines")
		fruit.NOIDFRUIT:
			print("noidfruit")
		fruit.POMEYES:
			print("pomeyes")
			blindness.color = Color.black
			yield(get_tree().create_timer(effect_time[fruit.POMEYES]), "timeout")
			blindness.color = Color.white
		fruit.THORNFRUIT:
			print("thornfruit")
		fruit.NEUTRAROOTS:
			print("neutraroots")
