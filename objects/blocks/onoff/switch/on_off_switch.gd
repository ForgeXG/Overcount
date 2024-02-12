extends CharacterBody2D

@export var manual : bool = true
@export var s_group : int = 1
var on : bool = false
@export var cooldown : float = 0.5 # Seconds

func _ready():
	modulate = get_parent().get_node("SquareTileMap").modulate
	$SwitchTimer.wait_time = cooldown
	$SwitchTimer.one_shot = manual
	if !manual:
		$Animations.material = preload("res://materials/shade/contrast.tres")

func _process(_delta):
	if on:
		$Animations.animation = "on"
	else:
		$Animations.animation = "off"
	modulate.a = 1 - $SwitchTimer.time_left / cooldown / 2
	

func _physics_process(delta):
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var coll = collision.get_collider()
		if (coll.is_in_group("Player") or coll.is_in_group("Enemies")) and $SwitchTimer.time_left <= 0.01 and manual:
			get_tree().call_group("OnOff", "switch", s_group)
			$SwitchTimer.start(cooldown)

func switch(switch_group : int):
	if switch_group == s_group:
		on = !on


func _on_timeout():
	if !manual:
		get_tree().call_group("OnOff", "switch", s_group)
