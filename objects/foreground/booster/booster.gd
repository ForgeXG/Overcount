extends Area2D

@export var velocity_add : int = 100
@export var max_cooldown : int = 20
var cooldown : int = 0
var start_scale : Vector2 = Vector2(1, 1)

func _ready():
	start_scale = scale

func _process(_delta):
	if cooldown > 0:
		modulate = Color(0.5, 0.5, 0.5, 0.8)
		cooldown -= 1
	else:
		modulate = Color.WHITE
	scale = start_scale * (1.1 + (sin(Time.get_ticks_msec() / 200) / 10))

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.velocity = Vector2(velocity_add, 0).rotated(rotation)
		body.mach = 2 * (body.velocity.x / body.walk_spd - 1)
		body.s_frames = 30
		cooldown = max_cooldown
	elif body.is_in_group("Enemies"):
		body.velocity += Vector2(velocity_add, 0).rotated(rotation)
		cooldown = max_cooldown


func _draw():
	pass
