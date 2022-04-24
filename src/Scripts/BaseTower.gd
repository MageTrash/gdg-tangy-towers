extends Node2D


export(PackedScene) var bullet_scene := preload("res://Scenes/Objects/Bullet.tscn")
export(int, 50, 1000) var bullet_speed = 200
export(int, 1, 100) var bullet_damage = 1
export(float, 0.1, 200) var fire_rate = 5

onready var sight_area: Area2D = $SightArea
onready var muzzel: Position2D = $ShotPosition
onready var cooldown: Timer = $CooldownTimer
onready var targets: Array

var root1: float
var root2: float
var result: Vector2


func _ready() -> void:
	cooldown.wait_time = 1 / fire_rate
	sight_area.connect("area_entered", self, "in_sight")
	sight_area.connect("area_exited", self, "out_of_sight")
	$ExcludeSpawn.connect("body_exited", self, "left_spawn_area")


func left_spawn_area(body: PhysicsBody2D) -> void:
	if body.is_in_group("Player"):
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)


func in_sight(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		targets.append(area.get_parent())


func out_of_sight(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		targets.erase(area.get_parent())


func _process(delta: float) -> void:
	if targets and cooldown.is_stopped():
		if predict_position(targets[0]):
			var bullet = bullet_scene.instance()
			bullet.speed = bullet_speed
			bullet.position = muzzel.position
			bullet.rotation = result.angle()
			bullet.damage = bullet_damage
			add_child(bullet)
			cooldown.start()


# solves a quadratic equation and returns how many solutions it has
# the values will be in the global variables root1 & root2
func solve_quadratic(a: float, b: float, c: float) -> int:
	var discriminant = pow(b, 2) - 4 * a * c
	if discriminant < 0:
		root1 = INF
		root2 = -root1
		return 0

	root1 = (-b + sqrt(discriminant))/(2 * a)
	root2 = (-b - sqrt(discriminant))/(2 * a)
	return 2 if discriminant > 0 else 1


func get_path_tangent(point_offset: float) -> Vector2:
	var point1: Vector2= Global.map_path.curve.interpolate_baked(point_offset)
	var point2: Vector2 = Global.map_path.curve.interpolate_baked(point_offset + 0.001)
	return (point2 - point1).normalized()


# returns the normalized direction to targets future position
# https://youtu.be/2zVwug_agr0 this is the maths behind this function
func predict_position(target: PathFollow2D) -> bool:
	var target_dir: Vector2 = get_path_tangent(target.offset)
	var target_to_self: Vector2 = muzzel.global_position - target.global_position
	var dist_to_target: float = target_to_self.length()
	var angle_at_target: float = target_to_self.angle_to(target_dir)
	var r = target.path_speed / bullet_speed
	if solve_quadratic(1 - pow(r, 2), 2 * r * dist_to_target * cos(angle_at_target), -(pow(dist_to_target, 2))) == 0:
		result = Vector2.ZERO
		return false
	var dist_to_predict: float = max(root1, root2)
	var t: float = dist_to_predict / bullet_speed
	var c: Vector2 = target.global_position + (target_dir * target.path_speed) * t
	result = (c - muzzel.global_position).normalized()
	return true
