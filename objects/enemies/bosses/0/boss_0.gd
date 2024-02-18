extends CharacterBody2D

@export var walk_spd : int = 80
var walk_spd_m : float = 1
@export var jump_force : float = 0
@export var stationary : bool = false
var start_pos = Vector2(0, 0)
var h_sign = 0

@export var hp : float = 0
@export var maxhp : float = 0
var dmg_effect = 0
var heal_effect = 0
var d_timer = -1 # No health because it's a zero
var maxd_timer = 1753 * 6
var cooldown = 0
@export var max_cooldown : int = 120

@export var min_radius : int = 16
@export var max_radius : int = 640
@export var detect_radius : int = 16
@export var fire_impulse : int = 250
@export var fire_lifetime : float = 180
var fire_angle = 0
var player_dist = 10**10

var atk_id : int = 1

@export var dmg : int = 5

@export var score : int = 1000

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
	# Attack-based tint
	if atk_id == 1:
		$Animations.modulate.r = max_cooldown / (cooldown + 1)
		$Animations.modulate.g = 1
		$Animations.modulate.b = 1
		$Animations.animation = "idle"
	elif atk_id == 2:
		$Animations.modulate.r = 1
		$Animations.modulate.g = max_cooldown / (cooldown + 1)
		$Animations.modulate.b = 1
		$Animations.animation = "idle"
	elif atk_id == 3:
		$Animations.modulate.r = 1
		$Animations.modulate.g = 1
		$Animations.modulate.b = max_cooldown / (cooldown + 1)
		$Animations.animation = "idle"
	elif atk_id == 4:
		$Animations.modulate.r = 1
		$Animations.modulate.g = cooldown / max_cooldown
		$Animations.modulate.b = cooldown / max_cooldown
		$Animations.animation = "mul0"
	else:
		$Animations.modulate.r = cooldown / max_cooldown
		$Animations.modulate.g = cooldown / max_cooldown
		$Animations.modulate.b = cooldown / max_cooldown
		$Animations.animation = "div0"
	# Health Control
	if dmg_effect > 0:
		dmg_effect -= 0.1
		hp -= 0.1
		if d_timer == 0:
			$Coll.set_deferred("disabled", true)
			velocity.x = randi_range(-100, 100) * (player.mach + 1)
			velocity.y = randi_range(-100, 100) * (player.mach + 1)
			
	if heal_effect > 0:
		heal_effect -= 0.1
		hp -= 0.1
		
	# Death
	if hp <= 0:
		if d_timer == -1:
			d_timer = maxd_timer
		elif d_timer > 0:
			d_timer -= 1
		elif d_timer == 0:
			$Coll.set_deferred("disabled", true)
			scale.x += 0.05
			scale.y += 0.05
			rotation += 0.05
			modulate.a = 0.4
			player.score += score
			get_tree().call_group("EscapeWall", "switch", 0)
			get_parent().get_node("LevelPortal").active = true
			queue_free()
		
	queue_redraw()

func _physics_process(delta):
	var key_jump = player.position.y < position.y - 2
	var key_accelerate = true
	player_dist = position.distance_to(player.position)
	fire_angle = atan((player.position.y - position.y) / (player.position.x - position.x))
	if player.position.x - position.x < 0:
		fire_angle -= PI
	
	if player_dist <= max_radius and player_dist >= min_radius:
		if walk_spd_m <= 1.2:
			h_sign = sign(player.position.x - position.x)
		if cooldown > 0:
			cooldown -= 1
	else:
		h_sign = 0
		cooldown = max_cooldown
	
	# Attacking
	if cooldown <= 0 and d_timer != -1:
		attack(atk_id)
	
	if !stationary:
		if not is_on_floor():
			velocity.y += gravity * delta
	
		if key_jump:
			if is_on_floor():
				velocity.y = jump_force
	
	velocity.x = h_sign * (walk_spd * walk_spd_m)
	if walk_spd_m > 1.1:
		walk_spd_m *= 0.99
	else:
		walk_spd_m = 1
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() == player and player.mach < 3:
			if player.i_frames == 0:
				player.i_frames = 60
				player.dmg_effect += dmg
				if float(d_timer) / maxd_timer <= 0.5:
					player.dmg_effect += dmg
				player.s_frames = 30
				player.velocity.x = -sign(position.x - player.position.x) * player.walk_spd * 0.5
				player.velocity.y = player.jump_force * 1
			if position.y < collision.get_collider().position.y and !stationary:
				velocity.y = -180
		elif collision.get_collider().is_in_group("Enemies"):
			pass
	
	# Abyss Death
	if position.y > 0:
		player.score += score
		queue_free()
	
	
func attack(id : int):
	match id:
		1:
			walk_spd_m = 4
			cooldown = max_cooldown
			if float(d_timer) / maxd_timer <= 0.5:
				velocity.y -= 500
				cooldown /= 4
		2:
			# Fires an arc of bullets
			var min_angle : int = fire_angle - 30
			var max_angle : int = fire_angle + 30
			var step : int = 15 * float(d_timer) / maxd_timer + 2
			if float(d_timer) / maxd_timer <= 0.5:
				min_angle += 20
				max_angle -= 20
				step = 2
			for i in range(min_angle, max_angle, step):
				var bullet = preload("res://objects/enemies/enemy_4_laser.tscn").instantiate()
				add_sibling(bullet)
				
				# bullet.apply_central_impulse(Vector2(fire_impulse, 0).rotated(fire_angle + deg_to_rad(i)))
				bullet.apply_central_impulse(
				Vector2(fire_impulse*cos(fire_angle + deg_to_rad(i))*0.8,
						fire_impulse*sin(fire_angle + deg_to_rad(i))))
				
				bullet.position = position + Vector2(0, 0).rotated(fire_angle + deg_to_rad(i))
				bullet.dmg = 1
				bullet.rotation = fire_angle + deg_to_rad(i)
				bullet.d_timer = fire_lifetime * 0.6
				bullet.maxd_timer = fire_lifetime * 0.6
				cooldown = max_cooldown
				$Animations.animation = "idle"
				if float(d_timer) / maxd_timer <= 0.5:
					bullet.apply_central_impulse(Vector2(fire_impulse * 0.5, 0).rotated(fire_angle + deg_to_rad(i)))
					bullet.dmg = 2
					bullet.scale.x *= 1.2
					bullet.scale.y *= 1.2
		3:
			# Summons 1 (hard 2) of the same number from 1 to 4 (x-x=0)
			var spawn_list : Array = [preload("res://objects/enemies/enemy_1.tscn"),
			preload("res://objects/enemies/enemy_2.tscn"),
			preload("res://objects/enemies/enemy_3.tscn"),
			preload("res://objects/enemies/enemy_4.tscn")]
			var spawn_ind = randi_range(0, 0)
			if float(d_timer) / float(maxd_timer) <= 0.5:
				spawn_ind = randi_range(0, 2)
			for i in range(2):
				var spawned = spawn_list[spawn_ind].instantiate()
				add_sibling(spawned)
				spawned.position = position + Vector2(i * 32, -64)
				if float(d_timer) / maxd_timer > 0.5:
					break
			cooldown = max_cooldown * 0.8
		4:
			var bullet = preload("res://objects/enemies/bosses/0/bullets/mul0/mul0_bullet.tscn").instantiate()
			add_sibling(bullet)
			bullet.apply_central_impulse(Vector2(fire_impulse * 0.6, 0).rotated(fire_angle))
			bullet.position = position + Vector2(8, 0).rotated(fire_angle)
			bullet.rotation = fire_angle
			bullet.apply_scale(Vector2(3, 3))
			bullet.d_timer = fire_lifetime * 3
			bullet.maxd_timer = fire_lifetime * 3
			cooldown = max_cooldown * 2
			$Animations.animation = "idle"
		5:
			var bullet = preload("res://objects/enemies/bosses/0/bullets/div0/div0_bullet.tscn").instantiate()
			add_sibling(bullet)
			bullet.apply_central_impulse(Vector2(fire_impulse * 0.6, 0).rotated(fire_angle))
			bullet.position = position + Vector2(8, 0).rotated(fire_angle)
			bullet.rotation = fire_angle
			bullet.apply_scale(Vector2(2, 2))
			bullet.d_timer = fire_lifetime * 3
			bullet.maxd_timer = fire_lifetime * 3
			cooldown = max_cooldown * 1.5
			$Animations.animation = "idle"
	
	if float(d_timer) / maxd_timer > 1 - 27 / 181.2:
		atk_id = [1, 1, 1, 1, 2].pick_random()
	elif float(d_timer) / maxd_timer > 1 - 51 / 181.2:
		atk_id = [1, 1, 2, 2, 2].pick_random()
	elif float(d_timer) / maxd_timer > 1 - 90 / 181.2:
		atk_id = [1, 2, 2, 3, 3].pick_random()
	elif float(d_timer) / maxd_timer > 1 - 115 / 181.2:
		atk_id = [1, 2, 3, 4, 4].pick_random()
	elif float(d_timer) / maxd_timer > 1 - 141 / 181.2:
		atk_id = [1, 2, 2, 3, 4, 5].pick_random()
	else:
		atk_id = [1, 1, 2, 3, 3, 4, 5, 5].pick_random()
		cooldown *= 0.75
	if atk_id == 4 and get_tree().get_first_node_in_group("Deadly") != null:
		atk_id = [1, 2, 3, 5].pick_random()

func _draw():
	var draw_color = Color(0.6, 0, 1, 0.2)
	if float(d_timer) / maxd_timer < 0.5:
		draw_color = Color(1, 0, 0.8, 0.3)
	if float(d_timer) / maxd_timer < 0.2:
		draw_color = Color(1, 0, 0, 0.4)
	draw_arc(Vector2(0, 0), 12,
	 -PI / 2, -PI / 2 + 2 * PI * d_timer / maxd_timer,
	 50, draw_color, 4, false)
	# for i in range(-90, 270, 90):
		# var notch_coords = Vector2(cos(i * PI / 180), sin(i * PI / 180))
		# if float(d_timer) / maxd_timer > float(i + 90) / 360:
			# draw_line(notch_coords * 14, notch_coords * 18, Color(0, 0, 0, 0.5), 2)
