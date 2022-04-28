extends Node2D

export(preload("res://Scripts/Global.gd").fruit) var fruit_type

onready var area: Area2D = $PickupArea

func _ready() -> void:
#	fruit_type = Global.rng.randi_range(0, Global.fruit.size() - 1)
	fruit_type = pick_random(Global.probability)
	area.connect("body_entered", self, "on_area_entered")


func pick_random(number_list: Array) -> int:
	var sum : int = 0
	for value in number_list:
		sum += value
	var rand_num : int = Global.rng.randi() % sum
	var index : int = 0
	for value in number_list:
		if rand_num < value:
			break
		else:
			rand_num -= value
			index += 1
	return index


func on_area_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		if body.is_building == false:
			Global.increment_fruit(fruit_type)
			# do something here like an animation? then delete
			queue_free()
