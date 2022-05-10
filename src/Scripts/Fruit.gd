extends Node2D

export(preload("res://Scripts/Global.gd").fruit) var fruit_type

onready var area : Area2D = $PickupArea
onready var sprite : AnimatedSprite = $AnimatedSprite

func _ready() -> void:
	fruit_type = pick_random(Global.fruit_probability)
	sprite.animation = Global.fruit.keys()[fruit_type].to_lower()
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
			SfxMan.play_fruitpickupsfx()
			queue_free()
