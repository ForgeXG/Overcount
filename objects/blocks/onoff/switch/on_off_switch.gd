extends CharacterBody2D

@export var stationary : bool = true
var start_pos : Vector2 = Vector2.ZERO
@export var manual : bool = true
@export var activation_sources : Array[String] = ["Player", "Enemies"]
@export var s_group : int = 1
var on : bool = false
@export var cooldown : float = 0.5 # Seconds
@export var active_dist = 512
var player_dist : float

var player

@export var draw_font : SystemFont

func _ready():
	start_pos = position
	player = get_tree().get_first_node_in_group("Player")
	modulate = get_parent().get_node("SquareTileMap").modulate
	$SwitchTimer.wait_time = cooldown
	$SwitchTimer.one_shot = manual
	if !manual:
		$Animations.material = preload("res://materials/shade/contrast.tres")
	if ("Laser" in activation_sources) or ("Bullet" in activation_sources):
		$Animations.material = preload("res://materials/shade/invert.tres")

func _process(_delta):
	modulate.a = 1 - $SwitchTimer.time_left / cooldown / 2
	queue_redraw()

func _physics_process(delta):
	player_dist = position.distance_to(player.position)
	move_and_slide()
	if position != start_pos and stationary:
		position = start_pos
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var coll = collision.get_collider()
		for j in activation_sources:
			if coll.is_in_group(j) and is_equal_approx($SwitchTimer.time_left, 0.0) and manual:
				print("Switch group " + str(s_group) + " toggled by " + j)
				get_tree().call_group("OnOff", "switch", s_group)
				$SwitchTimer.start(cooldown)
				break

func switch(switch_group : int):
	if switch_group == s_group and player_dist <= active_dist:
		on = !on
		if on:
			$Animations.animation = "on"
		else:
			$Animations.animation = "off"


func _on_timeout():
	if !manual:
		get_tree().call_group("OnOff", "switch", s_group)


func _draw():
	draw_string(draw_font, Vector2(-8, -8), str(floorf($SwitchTimer.time_left * 10) / 10), HORIZONTAL_ALIGNMENT_CENTER, -1, 12, 
	Color.WHITE)
