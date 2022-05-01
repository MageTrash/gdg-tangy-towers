extends Node2D

func _ready() -> void:
	Global.register_path_and_ysort($YSort/Path2D, $YSort/Enemies)

func _on_ExitButton_pressed():
	get_tree().change_scene('res://Scenes/UI/TitleScreen.tscn')


func _on_InWaveCheck_toggled(button_pressed):
	Global.in_wave = button_pressed
