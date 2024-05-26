extends CharacterBody2D

@export var walk_spd : int = 60
@export var jump_force : int = -400
var start_pos = Vector2(0, 0)
var h_sign = 0
var keep_vel_x = 0

@export var hp : float = 8
@export var maxhp : float = 8
var dmg_effect = 0
var heal_effect = 0
var d_timer = 60
var cooldown = 0
@export var max_cooldown : int = 30

@export var min_radius : int = 8
@export var max_radius : int = 144
@export var detect_radius : int = 8
@export var fire_impulse : int = 400
var fire_angle = 0
var player_dist = 10**10

@export var dmg : int = 8

@export var score : int = 32

var player

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	player = get_parent().get_node("Player")
	start_pos = position

func _process(_delta):
	# Animations Control
	# Flip
	$Animations.flip_h = h_sign > 0
	# Speed-based animations
	
	# Health Control
	if dmg_effect > 0:
		dmg_effect -= 0.1
		hp -= 0.1
		if hp - dmg_effect <= 0:
			$Coll.set_deferred("disabled", true)
			velocity.x = randi_range(-400, 400) * (player.mach + 1)
			velocity.y = randi_range(-50, 50) * (player.mach + 1)
			
	if heal_effect > 0:
		heal_effect -= 0.1
		hp -= 0.1
		
	# Death
	if hp <= 0:
		d_timer -= 1
		scale.x += 0.05
		scale.y += 0.05
		rotation += 0.05
		modulate.a = 0.4
		dmg = 0
	if d_timer == 0:
		player.score += score
		queue_free()
		
	queue_redraw()

func _physics_process(delta):
	var key_jump = false # player.position.y < position.y - 2
	var key_accelerate = true
	player_dist = position.distance_to(player.position)
	fire_angle = atan((player.position.y - position.y) / (player.position.x - position.x))
	if player.position.x - position.x < 0:
		fire_angle -= PI
	
	if player_dist <= max_radius and player_dist >= min_radius and hp > 0:
		h_sign = sign(player.position.x - position.x)
		if cooldown == 0:
			if hp > 0:
				player.position += Vector2(2, 0).rotated(fire_angle)
				player.position += Vector2(2, 0).rotated(fire_angle)
		else:
			cooldown -= 1
	else:
		h_sign = 0
		cooldown = max_cooldown
	
	if not is_on_floor():
		velocity.y += gravity * delta
	if key_jump and hp > 0:
		if is_on_floor():
			velocity.y = jump_force
	if is_on_floor() and cooldown == 0:
		velocity.x /= 2
		keep_vel_x /= 2
	
	# if cooldown > max_cooldown / 3:
		# velocity.x = keep_vel_x
	
	if hp > 0:
		velocity.x = h_sign * walk_spd
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() == player and hp > 0 and player.mach < 3:
			if player.i_frames == 0:
				player.i_frames = 60
				player.dmg_effect += dmg
				player.s_frames = 30
				player.velocity.x = -sign(position.x - player.position.x) * player.walk_spd * 2
				player.velocity.y = player.jump_force * 1
			if position.y < collision.get_collider().position.y:
				velocity.y = -180
	
	# Abyss Death
	if position.y > 0:
		player.score += score
		queue_free()

func _draw():
	var draw_color = Color(0.4, 0.25, 0.4, 1.1 - float(hp) / maxhp)
	draw_arc(Vector2(0, 0), 8,
	 -PI / 2, -PI / 2 + 2 * PI * float(hp) / maxhp,
	 7, draw_color, 4, false)
	
	draw_circle(Vector2(0, 0), max_radius * 2 / (scale.x + scale.y), Color(138.0/255, 146.0/255, 174.0/255, 0.6 * (1 - float(cooldown) / max_cooldown)))
	if cooldown == 0 and hp > 0:
		draw_line(Vector2(0, 2), (player.position - position) * 2 / (scale.x + scale.y), Color(138.0/255, 146.0/255, 174.0/255, 1), 2, false)