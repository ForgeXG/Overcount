extends NinePatchRect

@export var s_group : int = 0

func t_switch_material(self_group : int, sh : Shader):
	if self_group == s_group:
		material.shader = sh
