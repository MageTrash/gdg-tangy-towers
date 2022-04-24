extends Label


func _ready() -> void:
	Global.player.connect("building", self, "build_mode")

func build_mode(is_building) -> void:
	var message = "Place Towers?: "
	text = message + str("on" if is_building else "off")
