extends Label

export var fruit_index : int = 0

func _ready() -> void:
	Global.connect("count_change", self, "update_label")
	
func update_label(fruits) -> void:
	text = str(fruits[fruit_index])
