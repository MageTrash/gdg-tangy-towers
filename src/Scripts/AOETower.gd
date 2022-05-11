extends Node2D


export(PackedScene) var bullet_scene := preload("res://Scenes/Objects/Towers/SplashArea.tscn")
export(float, 1, 100) var bullet_damage : float = 8
export(float, 0.1, 200) var time_between_shot = 5


onready var sight_area: Area2D = $SightArea
onready var muzzel: Position2D = $ShotPosition
onready var cooldown: Timer = $CooldownTimer
onready var targets: Array


func _ready() -> void:
	cooldown.wait_time = time_between_shot
	Global.connect("tower_rate_change", self, "on_fire_rate_change")
	sight_area.connect("area_entered", self, "in_sight")
	sight_area.connect("area_exited", self, "out_of_sight")
	$ExcludeSpawn.connect("body_exited", self, "left_spawn_area")


func left_spawn_area(body: PhysicsBody2D) -> void:
	if body.is_in_group("Player"):
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)


func on_fire_rate_change(modifier: float) -> void:
	cooldown.wait_time = time_between_shot * (1 / modifier)


func in_sight(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		targets.append(area.get_parent())


func out_of_sight(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		targets.erase(area.get_parent())


func _process(_delta: float) -> void:
	if targets and cooldown.is_stopped():
		var bullet = bullet_scene.instance()
		bullet.set_as_toplevel(true)
		bullet.damage = bullet_damage * Global.tower_damage_mod
		bullet.global_position = targets[0].global_position
		add_child(bullet)
		cooldown.start()
