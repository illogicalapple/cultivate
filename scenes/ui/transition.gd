extends ColorRect

func _ready() -> void:
	material.set_shader_parameter("screen_width", size.x)
	material.set_shader_parameter("screen_height", size.y)
