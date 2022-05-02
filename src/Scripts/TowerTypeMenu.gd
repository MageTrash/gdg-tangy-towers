tool
extends VBoxContainer

var global_script = load("res://Scripts/Global.gd")
var fruit_names = global_script.fruit.keys()

var tower_name : String
var costs : Array = [0,0,0,0,0,0,0,0,0,0]

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

	properties.append({
		name = "tower_name",
		type = TYPE_STRING
	})

	properties.append({
		name = "description",
		type = TYPE_STRING,
	})

	return properties


func _set(property: String, value) -> bool:
	if property.begins_with("fruit_"):
		costs[global_script.fruit.get(property.trim_prefix("fruit_").to_upper())] = value
		return true
	else:
		return false


func _get(property: String):
	if property.begins_with("fruit_"):
		return costs[global_script.fruit.get(property.trim_prefix("fruit_").to_upper())]
	return null

func _ready() -> void:
	if name != tower_name and tower_name != "":
		name = tower_name
	$TowerName.text = name
	button.connect("pressed", self, "on_buy_pressed")


func on_buy_pressed() -> void:
	pass
