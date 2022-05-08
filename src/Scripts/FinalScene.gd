extends Node2D

func _ready() -> void:
	Global.register_path_and_ysort($YSort/Path2D, $YSort/Enemies)
	Global.game_end = false
	Global.wave_timer.wait_time = Global.start_wave_time
	Global.enemy_death_count = 0
	Global.player_health = Global.player_max_health
	Global.reset_fruit_counter()
	Global.wave_timer.start()


func _on_ExitButton_pressed():
	Global.game_end = true
	Global.cleanse_effects()
	get_tree().change_scene('res://Scenes/UI/TitleScreen.tscn')
