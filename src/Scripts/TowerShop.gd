extends Node2D


onready var shop_ui: Control = $CanvasLayer/ShopUI
onready var buy_area: Area2D = $BuyArea


func _ready() -> void:
	shop_ui.visible = false
	buy_area.connect("body_entered", self, "on_shop_entered")
	buy_area.connect("body_exited", self, "on_shop_exited")


func on_shop_entered(body: Node) -> void:
	shop_ui.visible = true


func on_shop_exited(body: Node) -> void:
	shop_ui.visible = false
