extends AnimatedSprite2D

@export var hspin = 0.02
@export var vspin = 0
@export var rot_spd = 0.01
var hspinval = 0
var vspinval = 0

var initial_xscale = 1
var initial_yscale = 1

func _ready():
	initial_xscale = scale.x
	initial_yscale = scale.y
	
func _process(delta):
	scale = Vector2(initial_xscale * cos(hspinval), initial_yscale * cos(vspinval))
	hspinval += hspin
	vspinval += vspin
	rotation += rot_spd * delta * 60
