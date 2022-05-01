extends Button

var label = load("res://Scripts/FruitCountLabel.gd").new()

func _ready():
	connect("in_shop", self, "on_shop_change")

func on_shop_change(in_shop) -> void:
	if in_shop:
		if Global.fruit_counter[0] >= 1:
			set_disabled(false)
		else:
			set_disabled(true)

func _on_Button_pressed():
	Global.fruit_counter[0] -= 1
#	var secondary = get_node("CanvasLayer/GridContainer/SLCounter")
#	connect("in_shop", secondary, "on_shop_change")
#	$SLCounter.update_label(Global.fruit_counter)
	# need to code labels to refresh
