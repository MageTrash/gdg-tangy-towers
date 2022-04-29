extends Node2D

func _ready() -> void:
	Global.register_path($YSort/Path2D)

func _on_ExitButton_pressed():
	get_tree().change_scene('res://Scenes/UI/TitleScreen.tscn')
