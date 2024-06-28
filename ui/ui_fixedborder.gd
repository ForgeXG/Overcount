extends NinePatchRect

var mat : ShaderMaterial

func _ready():
	mat = material
	mat.set("shader_parameter/pixelsize", size)
	print(size)
