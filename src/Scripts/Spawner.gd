extends TileMap


export(PackedScene) var spawned_object

func _ready() -> void:
	assert(spawned_object != null, "Add a scene to the spawned_object export variable for Spawner to work")
	spawn_random(1)


func spawn_random(amount: int) -> void:
	var list_of_tiles: Array = get_used_cells()
	assert(list_of_tiles.size() != 0, "You have not set any tiles to spawn objects")

	for i in amount:
		var obj = spawned_object.instance()
		# get random tile and get it's world position then center it in the tile
		var random_tile = list_of_tiles[randi_range(0, list_of_tiles.size())]
		var world_pos: Vector2 = map_to_world(random_tile)
		world_pos += cell_size/2
		obj.position = world_pos
		add_child(obj)

# e.g. randi_range(0, 5) will be a random integer 0, 1, 2, 3 or 4. 5 is excluded
func randi_range(from: int, to: int) -> int:
	return randi() % (to - from) + from
