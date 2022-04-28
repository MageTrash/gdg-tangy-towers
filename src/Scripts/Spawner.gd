extends TileMap


export(PackedScene) var spawn_object := preload("res://Scenes/Objects/Fruit.tscn")
export(NodePath) var group_node
export(int) var spawn_limit = 5
export(int) var spawn_amount = 3
export(float) var timer_length = 10.0
export(bool) var loop = true

onready var list_of_tiles: Array = get_used_cells()
onready var fruit_group = get_node_or_null(group_node)

func _ready() -> void:
	assert(spawn_object != null, "Add a scene to the spawn_object script variable")
	assert(list_of_tiles.size() != 0, "You have not set any tiles to spawn objects")
	assert(fruit_group != null, "Add a path to a node group to spawn fruit children e.g. ysort")
	if spawn_limit > list_of_tiles.size():
		spawn_limit = list_of_tiles.size()

	# set the tile to invisible
	tile_set.tile_set_modulate(0, Color(0 ,0, 0, 0))

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
			var random_tile = list_of_tiles[Global.randi_range(0, list_of_tiles.size())]
			var world_pos: Vector2 = map_to_world(random_tile)
			world_pos += cell_size/2
			obj.position = world_pos
			# check if there is any objects already spawned at world_pos
			valid_spot = check_no_objects(world_pos, "Spawnable")
		# once we've found a valid spot to spawn we add it as a child to Spawner
		fruit_group.add_child(obj)


# this will check if the given position has any collsions with the given group at that point
# returns true if there is no objects in the way
func check_no_objects(spawn_pos: Vector2, group: String) -> bool:
	var space = get_world_2d().direct_space_state
	for collision in space.intersect_point(spawn_pos, 32, [], 2147483647, true, true):
		if collision.collider.is_in_group("Spawnable"):
			return false
	return true
