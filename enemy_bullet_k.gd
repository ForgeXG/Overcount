extends Area2D
@export var rot_spd = 0
@export var dmg : int = 1
@export var hit_chance : float = 1
@export var sticky : bool = true
@export var blackhole : bool = false
@export var blackhole_radius : int = 0
@export var maxd_timer : float = -1
@export var fading : bool = true

@export var laser : bool = false
@export var scale_spd : Vector2 = Vector2(0, 0)
var d_timer : float = -1
var player : Player
var player_dist = 0
var player_angle = 0

func _ready():
	d_timer = maxd_timer
	player = get_parent().get_node("Player")

func _process(_delta):
	if d_timer > 0:
		d_timer -= 1
		if d_timer <= 0:
			queue_free()
	if fading:
		modulate.a = d_timer / maxd_timer
		
	queue_redraw()

func _physics_process(delta):
	rotation += rot_spd
	scale += scale_spd
	player_dist = position.distance_to(player.position)
	player_angle = atan((player.position.y - position.y) / (player.position.x - position.x))
	if player.position.x - position.x < 0:
		player_angle -= PI
	
	if blackhole:
		if player_dist <= blackhole_radius:
			player.position -= 2 * Vector2(cos(player_angle), -sin(player_angle))
	
	# move_and_slide()
	
	"""for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() == player and player.mach < 3:
			if player.i_frames == 0:
				if randf_range(0, 1) <= hit_chance:
					player.dmg_effect += dmg
				if !laser:
					queue_free()
		elif collision.get_collider().is_in_group("WallTileMap"):
			scale_spd = Vector2.ZERO"""

func _on_draw():
	if blackhole:
		draw_circle(Vector2(0, 0), blackhole_radius, Color(0, 0, 0, 0.4))
		if player_dist <= blackhole_radius:
			draw_line(Vector2(0, 0), Vector2(player.position - position).rotated(-rotation), Color.BLACK, 3, false)


func _on_body_entered(body):
	if body.is_in_group("Player"):
		if randf_range(0, 1) <= hit_chance:
			player.damage(dmg)
			var dmg_number = preload("res://ui/damage_number.tscn").instantiate()
			get_tree().current_scene.add_child(dmg_number)
			dmg_number.position = position
			dmg_number.text = "%.1f" % dmg
			dmg_number.target = "Player"
		if !laser:
			queue_free()
	elif body.is_in_group("WallTileMap"):
		scale_spd = Vector2.ZERO
