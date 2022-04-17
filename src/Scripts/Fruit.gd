extends Node2D

export(Global.fruit) var fruit_type = Global.fruit.APPLE


onready var area = $PickupArea

func _ready() -> void:
	area.connect("body_entered", self, "on_area_entered")


func on_area_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		print("maybe prompt for pick up? or just pick it up straight away")
		Global.increment_fruit(fruit_type)
