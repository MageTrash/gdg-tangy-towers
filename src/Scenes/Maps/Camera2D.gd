extends Camera2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Passes on our global effect type to the shader.
	$CanvasLayer/CurrentFilter.material.set_shader_param("effectType", Global.effect_type)
#	pass
