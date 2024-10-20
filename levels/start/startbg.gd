extends ColorRect

var mouse_val : Vector2 = Vector2.ZERO
func _process(delta: float) -> void:
	mouse_val = get_viewport().get_mouse_position() / 180
	material.set_shader_parameter("a", mouse_val.x * 2)
	material.set_shader_parameter("b", mouse_val.y * 2)
