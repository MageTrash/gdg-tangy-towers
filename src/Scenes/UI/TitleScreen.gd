extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for button in $Menu/CentreRow/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])
	MusicMan.play_menutrack()

func _on_Button_pressed(scene_to_load):
	if scene_to_load == null:
		get_tree().quit()
	get_tree().change_scene_to(scene_to_load)
