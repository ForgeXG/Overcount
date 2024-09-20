extends RigidBody2D

@export var draw_font : SystemFont

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var p_coll : int = 0
var last_safe_position : Vector2 = Vector2.ZERO
var player

func _ready():
	last_safe_position = global_position
	player = get_tree().get_first_node_in_group("Player")


func _process(_delta):
	modulate.r = float(p_coll) / 3
	modulate.g = float(p_coll) / 3
	queue_redraw()


func _physics_process(_delta):
	$Ray.rotation = -rotation
	if global_position.y > 0:
		linear_velocity = Vector2.ZERO
		global_position = last_safe_position
		player.damage(10)


func yeet(force : Vector2):
	if p_coll > 0:
		linear_velocity = force
		p_coll -= 1


func _on_body_entered(body):
	if $Ray.is_colliding():
		if $Ray.get_collider(0).is_in_group("WallTileMap") and global_position.y < 8:
			last_safe_position = global_position
			p_coll = 3
	if body.is_in_group("Player"):
		p_coll = 3

func _on_body_exited(body):
	pass # Replace with function body.


func _on_draw():
	draw_set_transform(Vector2.ZERO, -rotation)
	draw_string(draw_font, Vector2(0, -16), str(p_coll), HORIZONTAL_ALIGNMENT_FILL, -1, 12, Color.WHITE)
	if abs(linear_velocity.angle()) <= PI / 2:
		for i in range(0, 256, 1):
			draw_line(Vector2(i, p_traj(i)), Vector2(i + 1, p_traj(i + 1)), Color(0, 0, 1, 0.6), 2)
	else:
		for i in range(-256, 0, 1):
			draw_line(Vector2(i, p_traj(i)), Vector2(i + 1, p_traj(i + 1)), Color(0, 0, 1, 0.6), 2)


func p_traj(a):
	var fire_angle : float = linear_velocity.angle()
	var fire_speed : float = linear_velocity.length()
	return (tan(fire_angle) * a) + ((gravity * (a * a)) / (2 * (fire_speed * fire_speed) * cos(fire_angle) * cos(fire_angle)))
