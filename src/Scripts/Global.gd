extends Node
# This is a global script, it is not attached to anything and can be accessed from any script

# this list may change later
enum fruit {
	APPLE,
	BANANA,
	GRAPE,
}

# This array will hold the counter for each fruit
onready var fruit_counter = []


# This function will be called to increment certain fruit counts
# to use in another script e.g. Global.increment_fruit(Global.fruit.APPLE)
func increment_fruit(fruit_type: int) -> void:
	fruit_counter[fruit_type] += 1
