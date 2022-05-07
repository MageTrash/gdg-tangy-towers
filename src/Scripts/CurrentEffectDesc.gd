extends Label
	
func _ready():
	Global.connect("new_fruit", self, "update_texture")
	Global.connect("cleanse_effects", self, "cleanse_effects")

func update_texture(fruit_type):
	match fruit_type:
		0: set_text("* inverted controls!\n* enemies reversed")
		1: set_text("+ player speed\n+ tower fire rate")
		2: set_text("* player blinded!\n+ tower damage")
		3: set_text("+ enemy speed\n+ enemy health")
		4: set_text("???")

func cleanse_effects():
	set_text("")
