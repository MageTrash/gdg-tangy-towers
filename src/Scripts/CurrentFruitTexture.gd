extends TextureRect

var bulbfruit = preload("res://Art n Music/Fruit Sprites/bulbfruit.png")
var flashfruit = preload("res://Art n Music/Fruit Sprites/flashfruit.png")
var neutraroots = preload("res://Art n Music/Fruit Sprites/neutraroots.png")
var pomeyes = preload("res://Art n Music/Fruit Sprites/pomeyes.png")
var spiralines = preload("res://Art n Music/Fruit Sprites/spiralines.png")

func _ready():
	Global.connect("new_fruit", self, "update_texture")
	Global.connect("cleanse_effects", self, "cleanse_effects")

func update_texture(fruit_type):
	match fruit_type:
		0: set_texture(spiralines)
		1: set_texture(flashfruit)
		2: set_texture(pomeyes)
		3: set_texture(bulbfruit)
		4: set_texture(neutraroots)

func cleanse_effects():
	set_texture(null)
