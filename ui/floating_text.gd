extends RichTextLabel

@export var shake : float = 1
var timer = 0

func _process(_delta):
	position.y += sin(shake*timer/15)/15
	timer += 1
