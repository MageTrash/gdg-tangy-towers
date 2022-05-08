extends ProgressBar

onready var health_grad : Gradient = preload("res://Scenes/UI/HealthGradient.tres")
onready var stylebox = get("custom_styles/fg")
onready var max_health = Global.player_health

func _ready() -> void:
	max_value = max_health
	Global.connect("health_change", self, "on_health_change")
	stylebox.set_bg_color(health_grad.interpolate(1.0))


func on_health_change(new_health: int) -> void:
	value = new_health
	stylebox.set_bg_color(health_grad.interpolate(value / max_health))

