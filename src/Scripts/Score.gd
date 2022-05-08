extends Label

onready var message : String = "Your Score: "

func _ready() -> void:
	text = message + var2str(Global.score)
