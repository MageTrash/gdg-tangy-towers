extends ProgressBar


func _ready() -> void:
	value = 0.0


func _process(_delta: float) -> void:
	if not Global.effect_timer.is_stopped():
		max_value = Global.effect_timer.wait_time
		value = Global.effect_timer.time_left
