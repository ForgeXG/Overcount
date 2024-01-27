extends PointLight2D
@export var rot_spd : float = 0.01 # Radians
func _process(_delta):
	rotation += rot_spd * _delta * 60
