extends CharacterBody2D

@export var walk_spd : int = 0
@export var jump_force : int = 0
@export var stationary : bool = true
var start_pos = Vector2(0, 0)
var h_sign = 0

@export var hp : float = 4
@export var maxhp : float = 4
var dmg_effect = 0
var heal_effect = 0
var d_timer = 60
var cooldown = 0
@export var max_cooldown : int = 60

@export var min_radius : int = 16
@export var max_radius : int = 256
@export var detect_radius : int = 16
@export var fire_impulse : int = 400
@export var fire_lifetime : float = 90
var fire_angle = 0
var player_dist = 10**10

@export var dmg : int = 1

@export var score : int = 8

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
		if hp <= 0:
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
	var key_jump = player.position.y < position.y - 2
	var key_accelerate = true
	player_dist = position.distance_to(player.position)
	fire_angle = atan((player.position.y - position.y) / (player.position.x - position.x))
	if player.position.x - position.x < 0:
		fire_angle -= PI
	
	if player_dist <= max_radius and player_dist >= min_radius and hp > 0:
		h_sign = sign(player.position.x - position.x)
		if cooldown > 0:
			cooldown -= 1
		$Animations.animation = "charge"
	else:
		h_sign = 0
		cooldown = max_cooldown
		$Animations.animation = "idle"
		
	if cooldown == 0 and hp > 0:
		# Fire Conditions
		if $Animations.frame == 12:
			for i in range(-30, 50, 20):
				var bullet = preload("res://objects/enemies/enemy_4_laser.tscn").instantiate()
				add_sibling(bullet)
				
				bullet.apply_central_impulse(Vector2(fire_impulse, 0).rotated(fire_angle + deg_to_rad(i)))
				bullet.position = position + Vector2(0, 0).rotated(fire_angle + deg_to_rad(i))
				bullet.dmg = dmg
				bullet.rotation = fire_angle + deg_to_rad(i)
				bullet.d_timer = fire_lifetime
				bullet.maxd_timer = fire_lifetime
				cooldown = max_cooldown
				$Animations.animation = "idle"
	
	if !stationary:
		if not is_on_floor():
			velocity.y += gravity * delta
	
		if key_jump and hp > 0:
			if is_on_floor():
				velocity.y = jump_force
	
	if hp > 0:
		velocity.x = h_sign * walk_spd
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() == player and hp > 0 and player.mach < 3:
			if player.i_frames == 0:
				player.i_frames = 60
				player.dmg_effect += ceil(dmg / 3)
				player.s_frames = 30
				player.velocity.x = -sign(position.x - player.position.x) * player.walk_spd * 0.5
				player.velocity.y = player.jump_force * 1
			if position.y < collision.get_collider().position.y and !stationary:
				velocity.y = -180
	
	# Abyss Death
	if position.y > 0:
		player.score += score
		queue_free()


func _draw():
	draw_circle(Vector2(0, 0), max_radius, Color(0, 0, 0.9, 0.1))
	if player_dist <= max_radius and player_dist >= min_radius and hp > 0:
		draw_line(Vector2(0, 0), player.position - position, Color(0.3, 0.3, 1, 0.5), 2*cooldown/max_cooldown, false)