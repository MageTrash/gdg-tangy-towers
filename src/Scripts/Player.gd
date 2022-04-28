extends KinematicBody2D

# Note: you can edit the export values in the inspector window
# The higher the speed the faster the player will move
export(float) var speed : float = 80.0
# If friction is 1 then the player will stop instantly
# If it's higher then the player will slide to a stop
export(float, 1, 20) var friction : float = 4.0
export(float, 0.0, 1.0) var slow_factor : float = 0.7


signal building(is_building)

onready var is_building: bool = false
onready var raw_direction: Vector2
onready var direction: Vector2
onready var velocity: Vector2

func _ready() -> void:
	# give global a reference to player from anywhere
	Global.register_player(self)

func _physics_process(delta: float) -> void:
	# This will get a normalized Vector2 direction of where the player want's to move
	raw_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	raw_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	direction = raw_direction.normalized()


	# This checks if the user wants to move.
	# If they do then we move in the direction they are inputing with the speed we choose.
	# If they are not pressing any movement keys then we slow down the player to a stop,
	# so that the player slows down gradually instead of stopping instantly.
	if direction:
		velocity = direction * speed * Global.player_speed_mod
	else:
		velocity.x = move_toward(velocity.x, 0.0, (speed*Global.player_speed_mod)/friction)
		velocity.y = move_toward(velocity.y, 0.0, (speed*Global.player_speed_mod)/friction)
	# If the player presses Ctrl/Shift, they will slow down.
	if Input.get_action_strength("move_slow"):
		velocity *= slow_factor


	velocity = move_and_slide(velocity)

var tower = preload("res://Scenes/Objects/BaseTower.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_E:
			# toggle is_building
			is_building = !is_building
			emit_signal("building", is_building)

		# check if towers collisionshape intersects with anything else
		if event.pressed and event.scancode == KEY_SPACE and is_building:
			var current_tower = tower.instance()
			var tower_shape = current_tower.get_node("StaticBody2D/CollisionShape2D")
			var space = get_world_2d().direct_space_state
			var query = Physics2DShapeQueryParameters.new()
#			query.collide_with_areas = true
			query.shape_rid = tower_shape.shape.get_rid()
			var shape_trans: Transform2D = tower_shape.transform
			shape_trans.origin = global_transform.origin
			query.transform = shape_trans
			query.exclude = [self, $ExcludeSpawn]
			var results = space.intersect_shape(query)
			if results == []:
				tower_shape.set_disabled(true)
				current_tower.global_position = global_position
				get_parent().get_node("Towers").add_child(current_tower)
			else:
				current_tower.queue_free()
