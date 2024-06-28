extends Area2D

@export var draw_font : SystemFont

@export var spawn_mode : int = 0 # 0 is One Shot, 1 is Periodic
@export var spawn_time : float = 1 # Seconds
@export var spawn_limit : int = 1
var spawn_counter : int = 0
@export var spawn_list : Array[PackedScene] = [preload("res://objects/enemies/enemy_1.tscn"),
			preload("res://objects/enemies/enemy_2.tscn"),
			preload("res://objects/enemies/enemy_3.tscn"),
			preload("res://objects/enemies/enemy_4.tscn"),
			preload("res://objects/enemies/enemy_5.tscn"),
			preload("res://objects/enemies/enemy_6.tscn"),
			preload("res://objects/enemies/enemy_7.tscn"),
			preload("res://objects/enemies/enemy_8.tscn")]
@export var list_ind : int = 0

var timer : float = 0

func _ready():
	$SpawnTimer.start(spawn_time)
	if spawn_mode == 0:
		$SpawnTimer.one_shot = true

func _process(_delta):
	modulate.h = $SpawnTimer.time_left / spawn_time
	modulate.s = 1 - $SpawnTimer.time_left / spawn_time
	queue_redraw()

func _physics_process(delta):
	scale = Vector2(1, 1) * (1 + abs(sin($SpawnTimer.time_left) * $SpawnTimer.time_left / spawn_time) / 2)
	timer += 60 * delta

func _on_timeout():
	if spawn_counter < spawn_limit:
		G.spawn_enemy(self, spawn_list[list_ind], global_position)
		spawn_counter += 1
	if spawn_mode == 0 or spawn_counter == spawn_limit:
		modulate.a = 0.4

func _on_draw():
	if modulate.a == 1 and false:
		draw_string(draw_font, Vector2(8, 0), str(int($SpawnTimer.time_left)), HORIZONTAL_ALIGNMENT_FILL, -1, 12, Color.WHITE)
