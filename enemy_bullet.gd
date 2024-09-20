extends RigidBody2D
@export var rot_spd = 0
@export var dmg : int = 1
@export var sticky : bool = true
@export var blackhole : bool = false
@export var blackhole_radius : int = 0
@export var maxd_timer : float = -1
@export var fading : bool = true
@export var homing : bool = false

var d_timer : float = -1
var player
var player_dist = 0
var player_angle = 0

func _ready():
	d_timer = maxd_timer
	player = get_tree().get_first_node_in_group("Player")

func _process(_delta):
	if d_timer > 0:
		d_timer -= 1
		if d_timer <= 0:
			queue_free()
	if fading:
		modulate.a = d_timer / maxd_timer
		
	queue_redraw()
	
func _physics_process(_delta):
	if homing:
		rotation = player_angle
	player_dist = position.distance_to(player.position)
	player_angle = atan((player.position.y - position.y) / (player.position.x - position.x))
	if player.position.x - position.x < 0:
		player_angle -= PI
	
	if blackhole:
		if player_dist <= blackhole_radius:
			player.position -= 2 * Vector2(cos(player_angle), -sin(player_angle))
	
	if homing:
		apply_central_force(linear_velocity.rotated(sign(player_angle - rotation)))

func _on_body_entered(body):
	if body.is_in_group("Enemies"):
		position.y -= 16
	elif body.is_in_group("Player"):
		if body.mach < 3 and body.i_frames == 0:
			body.dmg_effect += dmg - 0.01
			var dmg_number = preload("res://ui/damage_number.tscn").instantiate()
			get_tree().current_scene.add_child(dmg_number)
			dmg_number.position = position
			dmg_number.text = "%.1f" % dmg
			dmg_number.target = "Player"
			queue_free()
	elif body.is_in_group("WallTileMap"):
		if sticky:
			linear_velocity = Vector2(0, 0)
			angular_velocity = 0
			d_timer /= 2


func _on_draw():
	if blackhole:
		draw_circle(Vector2(0, 0), blackhole_radius, Color(0, 0, 0, 0.4))
		if player_dist <= blackhole_radius:
			draw_line(Vector2(0, 0), Vector2(player.position - position).rotated(-rotation), Color.BLACK, 3, false)
