extends Area2D

@export var velocity_add : int = 100
@export var max_cooldown : int = 20
var cooldown : int = 0
var start_scale : Vector2 = Vector2(1, 1)

var fire_angle : float = 0

func _ready():
	start_scale = scale

func _process(_delta):
	if cooldown > 0:
		modulate = Color(0.5, 0.5, 0.5, 0.8)
		cooldown -= 1
	else:
		modulate = Color.WHITE
	$Animations.scale = start_scale * (1.1 + (sin(Time.get_ticks_msec() / 200) / 10))
	
	fire_angle = rotation
	if fire_angle != clamp(fire_angle, -PI/2, PI/2):
		fire_angle -= PI

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.velocity = Vector2(velocity_add, 0).rotated(rotation)
		body.mach = 2 * (body.velocity.x / body.walk_spd - 1)
		body.s_frames = 30
		cooldown = max_cooldown
	elif body.is_in_group("Enemies"):
		body.velocity += Vector2(velocity_add, 0).rotated(rotation)
		cooldown = max_cooldown
	elif body.is_in_group("PiBall"):
		body.linear_velocity = Vector2(velocity_add, 0).rotated(rotation)


func _draw():
	draw_set_transform(Vector2.ZERO, 0, Vector2(1 / scale.x, 1 / scale.y))
	if is_equal_approx(cos(rotation), 0):
		pass
	elif fire_angle == clamp(fire_angle, -PI/2, PI/2):
		for i in range(0, 192, 1):
			draw_line(Vector2(i, p_traj(i)), Vector2(i + 1, p_traj(i + 1)), Color(1, 1, 0.16, 0.7), 2)
	else:
		for i in range(-192, 0, 1):
			draw_line(Vector2(i, p_traj(i)), Vector2(i + 1, p_traj(i + 1)), Color(1, 1, 0.16, 0.7), 2)

func p_traj(a):
	return (tan(fire_angle) * a) + ((gravity * (a * a))
	 / (2 * (velocity_add * velocity_add) * cos(fire_angle) * cos(fire_angle)))
