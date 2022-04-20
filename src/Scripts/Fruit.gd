extends Node2D

export(Global.fruit) var fruit_type


onready var area: Area2D = $PickupArea

func _ready() -> void:
	area.connect("body_entered", self, "on_area_entered")


func on_area_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		Global.increment_fruit(fruit_type)
		# do something here like an animation? then delete
		queue_free()
