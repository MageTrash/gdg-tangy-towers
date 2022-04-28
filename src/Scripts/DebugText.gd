extends Label


func _ready() -> void:
	Global.connect("count_change", self, "fruit_updated")


func fruit_updated(fruits) -> void:
	text = str(fruits)
