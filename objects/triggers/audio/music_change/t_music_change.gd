extends Area2D

@export var open : bool = true
@export var music_path : String = "res://audio/music/zenon.mp3"
@export var left_limit : float = 0
@export var right_limit : float = 10000
@export var volume : float = 0

func _on_body_entered(body):
	if body.is_in_group("Player") and open:
		activate()

func activate():
	get_tree().call_group("MusicPlayer", "change_music", music_path, left_limit, right_limit, volume)
	open = false
	modulate.a = 0
