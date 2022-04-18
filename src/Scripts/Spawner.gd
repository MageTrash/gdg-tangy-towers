extends TileMap


export(PackedScene) var spawn_object
export(int) var spawn_limit = 5
export(int) var spawn_amount = 3
export(float) var timer_length = 10.0
export(bool) var loop = true

onready var list_of_tiles: Array = get_used_cells()

func _ready() -> void:
	assert(spawn_object != null, "Add a scene to the spawn_object script variable")
	assert(list_of_tiles.size() != 0, "You have not set any tiles to spawn objects")
	if spawn_limit > list_of_tiles.size():
		spawn_limit = list_of_tiles.size()

	while loop:
		spawn_random(spawn_amount)
		yield(get_tree().create_timer(timer_length), "timeout")


func spawn_random(amount: int) -> void:
	for i in amount:
		# don't spawn anything if you've reached the max spawn limit
		if get_child_count() >= spawn_limit:
			return
		var obj = spawn_object.instance()
		var valid_spot: bool = false
		var overload: int = list_of_tiles.size()
		while valid_spot == false:
			# if it has been searching for a valid spot but can't find one after
			# overload amount of times then it will exit to prevent laggin and searching forever
			overload -= 1
			if overload <= 0:
				return
			# get random tile and get it's world position then center it in the tile
			var random_tile = list_of_tiles[randi_range(0, list_of_tiles.size())]
			var world_pos: Vector2 = map_to_world(random_tile)
			world_pos += cell_size/2
			obj.position = world_pos
			# check if there is any objects already spawned at world_pos
			valid_spot = check_no_objects(world_pos, "Spawnable")
		# once we've found a valid spot to spawn we add it as a child to Spawner
		add_child(obj)


# this will check if the given position has any collsions with the given group at that point
# returns true if there is no objects in the way
func check_no_objects(spawn_pos: Vector2, group: String) -> bool:
	var space = get_world_2d().direct_space_state
	for collision in space.intersect_point(spawn_pos, 32, [], 2147483647, true, true):
		if collision.collider.is_in_group("Spawnable"):
			return false
	return true


# e.g. randi_range(0, 5) will be a random integer 0, 1, 2, 3 or 4. 5 is excluded
func randi_range(from: int, to: int) -> int:
	return randi() % (to - from) + from