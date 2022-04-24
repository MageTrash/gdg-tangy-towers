extends Node
# This is a global script, it is not attached to anything and can be accessed from any script

# this list will change later
enum fruit {
	NOIDFRUIT,
	BANANA,
	GRAPE,
}


onready var player: KinematicBody2D
onready var map_path: Path2D
onready var wave_timer: Timer = Timer.new()
onready var enemy: PackedScene = preload("res://Scenes/Objects/BaseEnemy.tscn")

onready var enemies_at_end: int = 0
# This boolean will state if fruit collect goes to the counter or active effect
onready var in_wave: bool = true
# This array will hold the counter for each fruit
onready var fruit_counter = []


func _ready() -> void:
	randomize()

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
		fruit.NOIDFRUIT:
			Engine.time_scale = 2.0
			yield(get_tree().create_timer(5),"timeout")
			Engine.time_scale = 1.0
		fruit.BANANA:
			print("banana effect")
		# etc. . .
