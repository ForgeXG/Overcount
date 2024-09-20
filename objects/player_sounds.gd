extends AudioStreamPlayer2D

var sounds : Array = []
var player : CharacterBody2D

func _ready():
	player = get_parent()
	sounds = [load("res://audio/sounds/player/movement/silent.mp3"),
	load("res://audio/sounds/player/movement/walk.mp3"),
	load("res://audio/sounds/player/movement/runmach1.mp3"),
	load("res://audio/sounds/player/movement/runmach2.mp3"),
	load("res://audio/sounds/player/movement/runmach3.mp3")]
	play()

func _process(_delta):
	volume_db = get_parent().get_node("PlayerUI/Pause/SFXSlider").value
	AudioServer.get_bus_effect(0, 0).cutoff_hz = 1000 + 20000 * (player.hp / player.maxhp) ** 1
	if player.int_mach == 0:
		set_stream(sounds[0])
		play()
	if player.int_mach == 1:
		set_stream(sounds[1])
		play()
	if player.int_mach == 110:
		set_stream(sounds[2])
		play()
	if player.int_mach == 200:
		set_stream(sounds[3])
		play()
	if player.int_mach == 270:
		set_stream(sounds[4])
		play()
