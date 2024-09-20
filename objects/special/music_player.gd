extends AudioStreamPlayer2D
@export var left_limit : float = 0
@export var right_limit : float = 10000
@export var hp_pitch : bool = false
@export var volume_add : float = 0
@export var start_from : float = 0
var player

func _ready():
	if start_from == -1:
		play(left_limit)
	else:
		play(start_from)
	player = get_tree().get_first_node_in_group("Player")

func _process(_delta):
	if player != null:
		volume_db = player.get_node("PlayerUI/Pause/MusicSlider").value + volume_add
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
