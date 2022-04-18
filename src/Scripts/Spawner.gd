extends TileMap


export(PackedScene) var spawned_object

func _ready() -> void:
	assert(spawned_object != null, "Add a scene to the spawned_object export variable for Spawner to work")
	spawn_random()

func spawn_random() -> void:
	var list_of_tiles: Array = get_used_cells()
	assert(list_of_tiles.size() != 0, "You have not set any tiles to spawn objects")
