extends KinematicBody2D

# Note: you can edit the export values in the inspector window
# The higher the speed the faster the player will move
export(int) var speed: int = 80
# If friction is 1 then the player will stop instantly
# If it's higher then the player will slide to a stop
export(int, 1, 20) var friction: int = 4

onready var direction: Vector2
onready var velocity: Vector2

func _physics_process(delta: float) -> void:
	# This will get a normalized Vector2 direction of where the player want's to move
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	direction.normalized()

	# This checks if the user wants to move
	# If they do then we move in the direction they are inputing with the speed we choose
	# If they are not pressing any movement keys then we slow down the player to a stop
	# so that the player slows down gradually instead of stopping instantly
	if direction:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed/friction)
		velocity.y = move_toward(velocity.y, 0.0, speed/friction)

	velocity = move_and_slide(velocity)
