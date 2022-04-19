extends Node2D


onready var sight_area: Area2D = $SightArea
onready var targets: Array

func _ready() -> void:
	sight_area.connect("area_entered", self, "in_sight")
	sight_area.connect("area_exited", self, "out_of_sight")


func in_sight(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		targets.append(area)


func out_of_sight(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		targets.erase(area)


func solve_quadratic(a: float, b: float, c: float) -> Vector2:
	var discriminant = b * b - 4 * a * c
	var root1
	var root2
	if discriminant < 0:
		root1 = INF
		root2 = -root1
		return Vector2(root1, root2)

	root1 = (-b + sqrt(discriminant))/(2 * a)
	root2 = (-b - sqrt(discriminant))/(2 * a)
	return Vector2(root1, root2)


func predict_position(target: Vector2, target_vel: Vector2, shooter: Vector2, speed: float) -> Vector2:
	return Vector2.ZERO
