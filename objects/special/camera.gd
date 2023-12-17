extends Camera2D

@export var wiggle : float = 0
var wiggle_sine = 0
func _physics_process(_delta):
	rotation += sin(wiggle_sine)*wiggle
	wiggle_sine += PI/180
