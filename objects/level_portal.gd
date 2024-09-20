extends Area2D

@export var destination : String = "" # Destination scene path
@export var active : bool = false
@export var ball_required : bool = false
@export var s_group : int = 1
var player : CharacterBody2D
var music_player : AudioStreamPlayer2D
var jingles : Array[AudioStream] = [load("res://audio/music/vjs/vj_f.mp3"),
load("res://audio/music/vjs/vj_d.mp3"),
load("res://audio/music/vjs/vj_c.mp3"),
load("res://audio/music/vjs/vj_b.mp3"),
load("res://audio/music/vjs/vj_a.mp3"),
load("res://audio/music/vjs/vj_w.mp3")]

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	music_player = get_tree().get_first_node_in_group("MusicPlayer")
	if ball_required:
		modulate = Color.CYAN
		$Animations.sprite_frames = preload("res://objects/physical/piball/goal/animations/sf_piballgoal.tres")
		$Animations.play("default")


func _process(_delta):
	if active:
		modulate.a = 1
		modulate.g = 1
		modulate.b = 1
	else:
		modulate.a = 0.1
		modulate.g = 0.2
		modulate.b = 0.2


func _on_body_entered(body):
	if ((body.is_in_group("Player")) or (ball_required and body.is_in_group("PiBall"))) and active:
		# Player safety
		player.i_frames = 100000000
		player.escape_time_active = false
		player.heal_effect = 9999
		player.gravity = 0
		player.walk_spd = 0
		player.jump_force = 0
		# Save data
		G.coins += player.score + 50 * clampi(float(player.score) / float(player.maxscore) * 6, 0, 5)
		# End UI
		player.get_node("PlayerUI/TextTimer").text = "GG"
		player.escape_time = -1
		player.get_node("PlayerUI/WinScreen/ButtonNextLevel").destination = destination
		player.get_node("PlayerUI/WinScreen/WinAnim").play("win")
		music_player.stop()
		music_player.pitch_scale = 1.0
		music_player.stream = jingles[int(floor(float(player.score) / player.maxscore * 5))]
		music_player.play()
		
func activate(a : bool = true):
	active = a
	
	
func t_toggle(self_group : int, self_toggle : bool): # Tests self group and toggles
	if self_group == s_group:
		activate(self_toggle)
