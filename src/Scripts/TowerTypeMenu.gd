tool
extends VBoxContainer

export(String) var tower_name : String
export(PackedScene) var tower_scene

var global_script = preload("res://Scripts/Global.gd")
var fruit_names = global_script.fruit.keys()

var pricebox : PackedScene = preload("res://Scenes/UI/SinglePriceBox.tscn")
var costs : Array = [0,0,0,0,0,0,0,0,0,0]

onready var price_container = $MiddleMarginContainer/MiddleBoxContainer/PriceContainer
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
		price_update()
		return true
	else:
		return false


func _get(property: String):
	if property.begins_with("fruit_"):
		var index = global_script.fruit.get(property.trim_prefix("fruit_").to_upper())
		return costs[index]
	return null


func _ready() -> void:
	price_update()
	Global.connect("tower_count_change", self, "update_tower_price")
	# only run this when in game not in the editor
	if not Engine.editor_hint:
		assert(tower_scene != null, "add the tower scene to the export var")
		costs.resize(global_script.fruit.size())
		if name != tower_name and tower_name != "":
			name = tower_name
		$TowerName.text = name
		button.connect("pressed", get_node("../../../.."), "on_buy_pressed", [tower_scene, costs])


func price_update() -> void:
	if price_container == null: return
	if price_container.get_child_count() > 0:
		for child in price_container.get_children():
			# execute order 66
			child.queue_free()

	for i in range(0, costs.size()):
		if costs[i] == 0: continue
		var current_price_box = pricebox.instance()
		current_price_box.get_node("Label").text = "x " + str(costs[i])
		var texture_path = "res://Art n Music/Fruit Sprites/" + global_script.fruit.keys()[i].to_lower() + ".png"
		current_price_box.get_node("TextureRect").texture = load(texture_path)
		price_container.add_child(current_price_box)


func update_tower_price(tower_num: int) -> void:
	for i in range(0, costs.size()):
		if costs[i] == 0: continue
		costs[i] = tower_num + round(0.75*costs[i])
	price_update()
