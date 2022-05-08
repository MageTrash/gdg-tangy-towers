extends ProgressBar


func _process(_delta: float) -> void:
	max_value = Global.effect_timer.wait_time
	value = Global.effect_timer.time_left
