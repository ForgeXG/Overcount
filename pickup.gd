extends Area2D

@export var value : int = 1
@export var type : String = "Gem"
var d_timer : int = -1
var maxd_timer : int = 60
var player

var d_angle = randf_range(0, TAU)

func _process(_delta):
	player = get_parent().get_node("Player")
	if d_timer > 0:
		d_timer -= 1
		position += Vector2(float(d_timer) / maxd_timer * 2, 0).rotated(d_angle)
		scale -= Vector2(1.5, 1.5) / float(maxd_timer)
		modulate.a -= 1.0 / maxd_timer
	elif d_timer == 0:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("PiBall"):
		player.score += value
		d_timer = maxd_timer
