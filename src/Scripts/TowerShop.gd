extends Node2D

export(NodePath) var group_node

onready var shop_ui: Control = $CanvasLayer/ShopUI
onready var buy_area: Area2D = $BuyArea
onready var tower_group = get_node_or_null(group_node)

signal in_shop # : bool = true

func _ready() -> void:
	assert(tower_group != null, "add a path to a node to add towers as children e.g. ysort")
	shop_ui.visible = false
	buy_area.connect("body_entered", self, "on_shop_entered")
	buy_area.connect("body_exited", self, "on_shop_exited")

func on_shop_entered(_body: Node) -> void:
	shop_ui.visible = true

	emit_signal("in_shop", true)
	var secondary = get_node("CanvasLayer/ShopUI/TabContainer/Tower 1/MarginContainer/Button")
	connect("in_shop", secondary, "on_shop_change")

func on_shop_exited(_body: Node) -> void:
	shop_ui.visible = false

	emit_signal("in_shop", false)
	var secondary = get_node("CanvasLayer/ShopUI/TabContainer/Tower 1/MarginContainer/Button")
	connect("in_shop", secondary, "on_shop_change")
