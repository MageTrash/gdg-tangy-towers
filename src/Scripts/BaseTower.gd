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


