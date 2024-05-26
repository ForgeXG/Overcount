extends AudioStreamPlayer2D
@export var left_limit : float = 0
@export var right_limit : float = 10000
@export var hp_pitch : bool = false
var player

func _ready():
	play(left_limit)
	player = get_parent().get_node_or_null("Player")

func _process(_delta):
	if hp_pitch:
		if player.hp < 5:
			pitch_scale = 0.1
		else:
			pitch_scale = 1
	var music_pos = get_playback_position()
	if music_pos > right_limit:
		stop()
		play(left_limit)


func change_music(music_path : String, l_limit : float, r_limit : float, volume : float = 0):
	set_stream(load(music_path))
	left_limit = l_limit
	right_limit = r_limit
	volume_db = volume
	play(left_limit)

func _finished():
	play(left_limit)
