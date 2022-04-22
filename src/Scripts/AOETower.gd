extends Node2D


export(PackedScene) var bullet_scene := preload("res://Scenes/Objects/SplashArea.tscn")
export(int, 1, 100) var bullet_damage = 5
export(float, 0.1, 200) var time_between_shot = 5


onready var sight_area: Area2D = $SightArea
onready var muzzel: Position2D = $ShotPosition
onready var cooldown: Timer = $CooldownTimer
onready var targets: Array


func _ready() -> void:
	cooldown.wait_time = time_between_shot
	sight_area.connect("area_entered", self, "in_sight")
	sight_area.connect("area_exited", self, "out_of_sight")


func in_sight(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		targets.append(area.get_parent())


func out_of_sight(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		targets.erase(area.get_parent())


func _process(delta: float) -> void:
	if targets and cooldown.is_stopped():
		var bullet = bullet_scene.instance()
		bullet.set_as_toplevel(true)
		bullet.damage = bullet_damage
		bullet.global_position = targets[0].global_position
		add_child(bullet)
		cooldown.start()
