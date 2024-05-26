extends AudioStreamPlayer2D

var sounds : Array = []

func _ready():
	sounds = [load("res://audio/sounds/player/movement/silent.mp3"),
	load("res://audio/sounds/player/movement/walk.mp3"),
	load("res://audio/sounds/player/movement/runmach1.mp3"),
	load("res://audio/sounds/player/movement/runmach2.mp3"),
	load("res://audio/sounds/player/movement/runmach3.mp3")]
	play()

func _process(_delta):
	volume_db = get_parent().get_node("PlayerUI/Pause/SFXSlider").value
	if get_parent().int_mach == 0:
		set_stream(sounds[0])
		play()
	if get_parent().int_mach == 1:
		set_stream(sounds[1])
		play()
	if get_parent().int_mach == 110:
		set_stream(sounds[2])
		play()
	if get_parent().int_mach == 200:
		set_stream(sounds[3])
		play()
	if get_parent().int_mach == 270:
		set_stream(sounds[4])
		play()
