extends KinematicBody2D

# Note: you can edit the export values in the inspector windo
# The higher the speed the faster the player will move
export(float) var speed : float = 100.0
# If friction is 1 then the player will stop instantly
# If it's higher then the player will slide to a stop
export(float, 1, 20) var friction : float = 4.0
# Used to slow down player when they hold down ctrl/shift
export(float, 0.0, 1.0) var slow_factor : float = 0.7
export (int) var anim_speed : int = 10

onready var tower : PackedScene

onready var animated_sprite = $AnimatedSprite
onready var tower_sprite = $TowerSprites

onready var is_building: bool = false setget set_is_building
onready var raw_direction: Vector2
onready var direction: Vector2
onready var velocity: Vector2
onready var light : Light2D = $Light2D
onready var stunned : Vector2 = Vector2.ZERO

func _ready() -> void:
	light.enabled = false
	tower_sprite.visible = false
	# give global a reference to player from anywhere
	Global.register_player(self)
	Global.connect("toggle_player_light", self, "change_light")
	MusicMan.play_gameplaytrack()

func _physics_process(_delta: float) -> void:
	# This will get a normalized Vector2 direction of where the player want's to move
	raw_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	raw_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	direction = raw_direction.normalized() * Global.player_direction_mod

	if stunned:
		velocity = stunned
		stunned.x = move_toward(stunned.x, 0.0, speed/(friction*3))
		stunned.y = move_toward(stunned.y, 0.0, speed/(friction*3))
	# This checks if the user wants to move.
	# If they do then we move in the direction they are inputing with the speed we choose.
	# If they are not pressing any movement keys then we slow down the player to a stop,
	# so that the player slows down gradually instead of stopping instantly.
	if direction and !stunned:
		velocity = direction * speed * Global.player_speed_mod
	else:
		velocity.x = move_toward(velocity.x, 0.0, (speed*Global.player_speed_mod)/friction)
		velocity.y = move_toward(velocity.y, 0.0, (speed*Global.player_speed_mod)/friction)

	# If the player presses Ctrl/Shift, they will slow down.
	if Input.get_action_strength("move_slow"):
		velocity *= slow_factor

	velocity = move_and_slide(velocity)

	# Plays the animations depending on the player state.
	var is_moving = (direction.length() != 0.0)

	animated_sprite.set_speed_scale(Global.player_speed_mod)
	if is_building == true:
		if is_moving:
			animated_sprite.play("carry_moving")
		else:
			animated_sprite.play("carry_idle")
	else:
		if is_moving:
			animated_sprite.play("moving")
		else:
			animated_sprite.play("idle")


func place_tower() -> void:
	var current_tower = tower.instance()
	var tower_shape = current_tower.get_node("StaticBody2D/CollisionShape2D")
	var space = get_world_2d().direct_space_state
	var query = Physics2DShapeQueryParameters.new()
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
		set_is_building(false)
		Global.tower_count += 1
		SfxMan.play_towerplacesfx()
	else:
		current_tower.queue_free()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		# Check if tower's CollisionShape intersects with anything else
		if event.pressed and event.scancode == KEY_SPACE and is_building:
			place_tower()

		if OS.has_feature("debug"):
			if event.pressed and event.scancode == KEY_E:
				Global.decrement_player_health()

func change_light(toggle: bool) -> void:
	light.enabled = toggle


func set_is_building(value: bool) -> void:
	is_building = value
	if is_building:
		tower_sprite.animation = tower._bundled["names"][0]
		tower_sprite.visible = true
	else:
		tower_sprite.visible = false
