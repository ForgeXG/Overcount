extends CharacterBody2D

@export var walk_spd : int = 0
@export var jump_force : int = 0
@export var stationary : bool = true
var start_pos = Vector2(0, 0)
var h_sign = 0

@export var hp : float = 9
@export var maxhp : float = 9
var dmg_effect = 0
var heal_effect = 0
var d_timer = 60
var cooldown = 0
@export var max_cooldown : int = 240

@export var min_radius : int = 32
@export var max_radius : int = 240
@export var detect_radius : int = 32
@export var fire_impulse : int = 120
@export var fire_lifetime : float = 240
var fire_angle = 0
var player_dist = 10**10

@export var dmg : int = 1

@export var score : int = 5

var player

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	player = get_tree().get_first_node_in_group("Player")
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
			velocity.x = randi_range(-100, 100) * (player.mach + 1)
			velocity.y = randi_range(-100, 100) * (player.mach + 1)
		queue_redraw()
	
	if heal_effect > 0:
		heal_effect -= 0.1
		hp -= 0.1
		queue_redraw()
		
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
		
	if cooldown % 20 == 0 and cooldown < 60 and hp > 0:
		# Fire Conditions
		if $Animations.animation_finished and $Animations.animation == "charge":
			for i in range(-60, 120, 60):
				var bullet = preload("res://objects/enemies/enemy_9_rocket.tscn").instantiate()
				add_sibling(bullet)
				
				bullet.apply_central_impulse(Vector2(fire_impulse, 0).rotated(fire_angle + i * PI / 180.0))
				bullet.position = position + Vector2(0, 0).rotated(fire_angle)
				bullet.dmg = dmg
				bullet.d_timer = fire_lifetime
				bullet.maxd_timer = fire_lifetime
				bullet.homing = true
				if cooldown == 0:
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
				player.dmg_effect += ceil(dmg / 3.0)
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
	var draw_color = Color(1, 0, 0, 1 - float(hp) / maxhp)
	draw_arc(Vector2(0, 0), 8,
	 -PI / 2, -PI / 2 + 2 * PI * float(hp) / maxhp,
	7, draw_color, 4, false)
	
	draw_circle(Vector2(0, 0), detect_radius, Color(0, 0, 0, 0.4))
	draw_circle(Vector2(0, 0), max_radius, Color.hex(0xf9d5b744))
	if player_dist <= max_radius and player_dist >= min_radius and hp > 0:
		draw_line(Vector2(0, 0), player.position - position, Color(1, 0, 0, 0.5), 2*cooldown/max_cooldown, false)
