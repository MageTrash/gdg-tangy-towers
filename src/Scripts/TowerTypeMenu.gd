tool
extends VBoxContainer

export(String) var tower_name : String
export(PackedScene) var tower_scene

var global_script = preload("res://Scripts/Global.gd")
var fruit_names = global_script.fruit.keys()

var pricebox : PackedScene = preload("res://Scenes/UI/SinglePriceBox.tscn")
var costs : Array = [0,0,0,0,0,0,0,0,0,0]

onready var price_container : VBoxContainer = $MiddleMarginContainer/MiddleBoxContainer/PriceContainer
onready var button : Button = $ButtonMarginContainer/Button

func _get_property_list():
	var properties = []
	properties.append({
		name = "Tower Costs",
		type = TYPE_NIL,
		hint_string = "fruit_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})

	for fruit_name in fruit_names:
		properties.append({
			name = "fruit_" + fruit_name.to_lower(),
			type = TYPE_INT,
			usage = PROPERTY_USAGE_DEFAULT
		})

	return properties


func _set(property: String, value) -> bool:
	if property.begins_with("fruit_"):
		var index = global_script.fruit.get(property.trim_prefix("fruit_").to_upper())
		costs[index] = value
		return true
	else:
		return false


func _get(property: String):
	if property.begins_with("fruit_"):
		var index = global_script.fruit.get(property.trim_prefix("fruit_").to_upper())
		return costs[index]
	return null


func _ready() -> void:
	# only run this when in game not in the editor
	if not Engine.editor_hint:
		assert(tower_scene != null, "add the tower scene to the export var")
		costs.resize(global_script.fruit.size())
		if name != tower_name and tower_name != "":
			name = tower_name
		$TowerName.text = name
		button.connect("pressed", self, "on_buy_pressed")


func price_update() -> void:
	for child in price_container.get_children():
		# execute order 66
		child.queue_free()

	for i in global_script.fruit.size():
		var current_price_box = pricebox.instance()
		current_price_box.label.text = "x" + str(costs[i])
		price_container.add_child(current_price_box)


func on_buy_pressed() -> void:
	pass
