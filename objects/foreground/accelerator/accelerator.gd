extends Area2D

@export var max_cooldown : int = 20
var cooldown : int = 0

func _process(_delta):
	if cooldown > 0:
		modulate = Color(0.5, 0.5, 0.5, 0.8)
		cooldown -= 1
	else:
		modulate = Color.WHITE
	scale = Vector2(1, 1) * (1.1 + (sin(Time.get_ticks_msec() / 200) / 10))

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.mach += 1
		cooldown = max_cooldown
	elif body.is_in_group("Enemies"):
		body.velocity *= 2
		cooldown = max_cooldown
