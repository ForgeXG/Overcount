extends AudioStreamPlayer2D
@export var left_limit : float = 0
@export var right_limit : float = 10000

func _ready():
	play(left_limit)


func _process(_delta):
	var music_pos = get_playback_position()
	if music_pos > right_limit:
		stop()
		play(left_limit)


func _finished():
	play(left_limit)
