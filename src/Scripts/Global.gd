extends Node
# This is a global script, it is not attached to anything and can be accessed from any script

# this list will change later
enum fruit {
	APPLE,
	BANANA,
	GRAPE,
}

# This array will hold the counter for each fruit
onready var fruit_counter = []

func _ready() -> void:
	randomize()

	# This will add/set all the counters to zero at the start of the game
	for i in len(fruit.values()):
		fruit_counter.append(0)


# Call this function to increment certain fruit counts
func increment_fruit(fruit_type: int) -> void:
	fruit_counter[fruit_type] += 1
