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

	# if yes then go invis until player's in_build mode is off
	shop_ui.visible = false
	Global.player.is_building = true
	print(tower, price)
