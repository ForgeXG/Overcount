extends AudioStreamPlayer2D
@export var offset = 0

func _ready():
	play(offset)
