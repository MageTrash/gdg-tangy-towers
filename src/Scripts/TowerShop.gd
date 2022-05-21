extends Node2D

export(NodePath) var group_node

onready var shop_ui: Control = $CanvasLayer/ShopUI
onready var buy_area: Area2D = $BuyArea
onready var tower_group = get_node_or_null(group_node)


func _ready() -> void:
	assert(tower_group != null, "add a path to a node to add towers as children e.g. ysort")
	shop_ui.visible = false
	buy_area.connect("body_entered", self, "on_shop_entered")
	buy_area.connect("body_exited", self, "on_shop_exited")
	$AnimatedSprite.play("default")


func on_shop_entered(_body: Node) -> void:
	# if the player is building don't show shop
	if Global.player.is_building: return
	shop_ui.visible = true


func on_shop_exited(_body: Node) -> void:
	shop_ui.visible = false


func on_buy_pressed(tower: PackedScene, price: Array) -> void:
	# check if enough currency
	for i in range(0, Global.fruit.size()):
		if Global.fruit_counter[i] < price[i]:
			return

	var new_fruit_counter = Global.fruit_counter
	for i in range(0, Global.fruit.size()):
		if price[i] > 0:
			new_fruit_counter[i] -= price[i]

	Global.fruit_counter = new_fruit_counter

	# if yes then go invis until player's in_build mode is off
	shop_ui.visible = false
	Global.player.tower = tower
	Global.player.is_building = true
