extends Node2D

func _ready() -> void:
	Global.register_path_and_ysort($YSort/Path2D, $YSort/Enemies)
	Global.game_start()

func _on_ExitButton_pressed():
	Global.game_end = true
	get_tree().change_scene('res://Scenes/UI/TitleScreen.tscn')
