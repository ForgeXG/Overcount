extends Sprite2D

@export var start_scale : float = 1
@export var amplitude : float = 0.1
@export var speed : float = 1
var timer : int = 0

func _process(_delta):
	scale.x = start_scale + amplitude * sin(timer * speed)
	scale.y = start_scale + amplitude * sin(timer * speed)
	timer += 1
