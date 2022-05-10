extends Label
	
func _ready():
	Global.connect("new_fruit", self, "update_texture")
	Global.connect("cleanse_effects", self, "cleanse_effects")

func update_texture(fruit_type):
	match fruit_type:
		0: set_text("Enemies reversed!\nInverted controls!")
		1: set_text("+ Player speed\n+ Tower fire rate")
		2: set_text("Blinded Player!\n+ Tower damage")
		3: set_text("+ Enemy speed\n+ Enemy health")
		4: set_text("Randomises all stats!")

func cleanse_effects():
	set_text("")
