extends CharacterBody2D

@export var walk_spd : int = 80
var walk_spd_m : float = 1
var total_spd_m : float = 1
@export var jump_force : float = 0
@export var stationary : bool = false
var start_pos = Vector2(0, 0)
var h_sign = 0

@export var hp : float = 400
@export var maxhp : float = 400
var dmg_effect = 0
var heal_effect = 0
var d_timer : int = 120 # No health because it's a zero
var maxd_timer : int = 120
var cooldown = 0
@export var max_cooldown : int = 120
var attack_bias : float = 0.3

@export var min_radius : int = 16
@export var max_radius : int = 640
@export var detect_radius : int = 16
@export var fire_impulse : int = 250
@export var fire_lifetime : float = 180
var fire_angle = 0
var player_dist = 10**10

var atk_id : int = 1
var atk_angle : float = 0

@export var dmg : int = 5

@export var score : int = 1000

@export var music_player : AudioStreamPlayer2D

var m_pos : float = 0
@export var phase_loops : Array[Vector2]
var phase_ind : int = 0

@export var draw_font : SystemFont
var attack_str : String = ""

var player

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	start_pos = position

func _process(_delta):
	# Music Looping with Phases
	m_pos = music_player.get_playback_position()
	if hp / maxhp > 0.01:
		phase_ind = floor((1 - hp / maxhp * 0.99) * len(phase_loops))
		music_player.left_limit = phase_loops[phase_ind].x
		music_player.right_limit = phase_loops[phase_ind].y
	
	$Animations.flip_h = h_sign > 0
	# Attack-based tint and animations
	if atk_id == 1:
		$Animations.modulate.r = max_cooldown / (cooldown + 1)
		$Animations.modulate.g = 1
		$Animations.modulate.b = 1
		$Animations.animation = "idle"
	if atk_id in [2, 3]:
		$Animations.modulate.r = 1
		$Animations.modulate.g = max_cooldown / (cooldown + 1)
		$Animations.modulate.b = 1
		$Animations.animation = "line"
	elif atk_id in [4, 5]:
		$Animations.modulate.r = 1
		$Animations.modulate.g = 1
		$Animations.modulate.b = max_cooldown / (cooldown + 1)
		$Animations.animation = "polynomial"
	elif atk_id in [6, 7]:
		$Animations.modulate.r = max_cooldown / (cooldown + 1)
		$Animations.modulate.g = max_cooldown / (cooldown + 1)
		$Animations.modulate.b = max_cooldown / (cooldown + 1)
		$Animations.animation = "shape"
	elif atk_id in [8, 9]:
		$Animations.modulate.r = cooldown / max_cooldown
		$Animations.modulate.g = cooldown / max_cooldown
		$Animations.modulate.b = cooldown / max_cooldown
		$Animations.animation = "trig"
	if float(cooldown) / max_cooldown > 0.8:
		$Animations.animation = "idle"
	
	# Health Control
	if dmg_effect > 0:
		dmg_effect -= 0.1
		hp -= 0.1
		if d_timer == 0:
			$Coll.set_deferred("disabled", true)
			velocity.x = randi_range(-1000, 100) * (player.mach + 1)
			velocity.y = randi_range(-100, 1000) * (player.mach + 1)
			
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
			rotation += 0.2
			modulate.a = 0.4
			player.score += score
			get_tree().call_group("OnOff", "switch", 0)
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
	
	# if player_dist <= max_radius and player_dist >= min_radius:
	if walk_spd_m <= 1.5:
		h_sign = sign(player.position.x - position.x)
	if cooldown > 0:
		cooldown -= 1
	# else:
		# h_sign = 0
		# cooldown = max_cooldown
	
	# Attacking
	attack_bias = 0.3
	if m_pos == clamp(m_pos, phase_loops[0].x, phase_loops[0].y):
		attack_bias = 0.2
		total_spd_m = 0.75
	elif m_pos == clamp(m_pos, phase_loops[3].x, phase_loops[3].y):
		attack_bias = 0.4
		total_spd_m = 1.25
	elif m_pos == clamp(m_pos, phase_loops[4].x, phase_loops[4].y):
		attack_bias = 0.6
		total_spd_m = 1.5
	elif m_pos == clamp(m_pos, phase_loops[5].x, phase_loops[5].y):
		attack_bias = 0.7
		total_spd_m = 1.5
	elif m_pos == clamp(m_pos, phase_loops[6].x, phase_loops[6].y):
		attack_bias = 0.2
		total_spd_m = 0.75
	
	if float(cooldown) / max_cooldown <= attack_bias and d_timer != -1:
		attack(atk_id)
	
	if !stationary:
		if not is_on_floor():
			velocity.y += gravity * delta
	
		if key_jump:
			if is_on_floor():
				velocity.y = jump_force
	
	velocity.x = h_sign * (walk_spd * walk_spd_m) * total_spd_m
	if walk_spd_m > 1.1:
		walk_spd_m *= 0.99
		if is_on_wall() and hp / maxhp < 0.5:
			walk_spd_m *= 0.9
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
			if cooldown == 0:
				h_sign = sign(player.position.x - position.x)
				walk_spd_m = 3 * maxhp / (hp + 10)
				if float(d_timer) / maxd_timer <= 0.5:
					velocity.y -= 500
		2:
			if int(cooldown) % 4 == 0:
				# Line of bullets attack
				if attack_bias - 0.05 <= float(cooldown) / max_cooldown and float(cooldown) / max_cooldown <= attack_bias:
					atk_angle = fire_angle
				var bullet = preload("res://objects/enemies/enemy_4_laser.tscn").instantiate()
				add_sibling(bullet)
			
				bullet.apply_central_impulse(
				Vector2(fire_impulse*cos(atk_angle)*0.9,
						fire_impulse*sin(atk_angle)*0.9))
				
				bullet.position = position + Vector2(0, 0).rotated(atk_angle)
				bullet.dmg = 1
				bullet.rotation = atk_angle
				bullet.d_timer = fire_lifetime * 0.6
				bullet.maxd_timer = fire_lifetime * 0.6
				if float(hp) / maxhp <= 0.5:
					bullet.apply_central_impulse(Vector2(fire_impulse * 0.3, 0).rotated(atk_angle))
					bullet.scale.x *= 1.2
					bullet.scale.y *= 1.2
		3:
			if int(cooldown) % 5 == 0:
				if attack_bias - 0.05 <= float(cooldown) / max_cooldown and float(cooldown) / max_cooldown <= attack_bias:
					atk_angle = fire_angle
				for i in range(-30, 50, 20):
					var bullet = preload("res://objects/enemies/enemy_4_laser.tscn").instantiate()
					add_sibling(bullet)
			
					bullet.apply_central_impulse(
					Vector2(fire_impulse*cos(atk_angle + deg_to_rad(i))*1.3,
						fire_impulse*sin(atk_angle + deg_to_rad(i))*1.3))
				
					bullet.position = position + Vector2(0, 0).rotated(atk_angle + deg_to_rad(i))
					bullet.dmg = 1
					bullet.rotation = atk_angle + deg_to_rad(i)
					bullet.d_timer = fire_lifetime * 0.3
					bullet.maxd_timer = fire_lifetime * 0.3
					if float(hp) / maxhp <= 0.5:
						bullet.apply_central_impulse(Vector2(fire_impulse * 0.3, 0).rotated(atk_angle + deg_to_rad(i)))
						bullet.scale.x *= 1.2
						bullet.scale.y *= 1.2
					cooldown = clamp(cooldown - 2, 0, 1000000)
		4:
			# Fires a parabolic wave of bullets
			if attack_bias - 0.05 <= float(cooldown) / max_cooldown and float(cooldown) / max_cooldown <= attack_bias:
				atk_angle = acos(sign(player.position.x - position.x))
			var left_limit : int = -6
			var right_limit : int = 6
			var step : int = 1
			var rand_factor : float = randf_range(0.7, 1.3)
			for i in range(left_limit, right_limit, step):
				var bullet = preload("res://objects/enemies/enemy_3_bullet.tscn").instantiate()
				add_sibling(bullet)
			
				bullet.apply_central_impulse(
				Vector2(fire_impulse*cos(atk_angle)*rand_factor,
					fire_impulse*sin(atk_angle)))
				
				bullet.position = position + Vector2(i * 6 / rand_factor, i * i * 0.8 - 25)
				bullet.dmg = 1
				bullet.rotation = atk_angle + deg_to_rad(i)
				bullet.d_timer = fire_lifetime
				bullet.maxd_timer = fire_lifetime
				if float(hp) / maxhp <= 0.5:
					bullet.apply_central_impulse(Vector2(fire_impulse * 0.4, 0).rotated(atk_angle))
					bullet.scale.x *= 1.2
					bullet.scale.y *= 1.2
			cooldown = 0
		5:
			# Fires a cubic wave of bullets
			if attack_bias - 0.05 <= float(cooldown) / max_cooldown and float(cooldown) / max_cooldown <= attack_bias:
				atk_angle = acos(sign(player.position.x - position.x))
			var left_limit : int = -9
			var right_limit : int = 9
			var step : int = 1
			for i in range(left_limit, right_limit, step):
				var bullet = preload("res://objects/enemies/enemy_3_bullet.tscn").instantiate()
				add_sibling(bullet)
			
				bullet.apply_central_impulse(
				Vector2(fire_impulse*cos(atk_angle)*0.6,
					fire_impulse*sin(atk_angle)*0.6))
				
				bullet.position = position + Vector2(i * 8, i * i * i / 5 - 144)
				bullet.dmg = 1
				bullet.rotation = atk_angle + deg_to_rad(i)
				bullet.d_timer = fire_lifetime
				bullet.maxd_timer = fire_lifetime
				if float(hp) / maxhp <= 0.5:
					bullet.apply_central_impulse(Vector2(fire_impulse * 0.4, 0).rotated(atk_angle))
					bullet.dmg = 2
					bullet.scale.x *= 1.2
					bullet.scale.y *= 1.2
			cooldown = 0
		6:
			# Fires a circle of bullets
			if attack_bias - 0.05 <= float(cooldown) / max_cooldown and float(cooldown) / max_cooldown <= attack_bias:
				atk_angle = acos(sign(player.position.x - position.x))
			for i in range(0, 359, 10):
				var bullet = preload("res://objects/enemies/enemy_3_bullet.tscn").instantiate()
				add_sibling(bullet)
			
				bullet.apply_central_impulse(
				Vector2(fire_impulse*cos(atk_angle)*0.5,
					fire_impulse*sin(atk_angle)*0.5))
				
				bullet.position = position + Vector2(0, -20) + Vector2(32, 0).rotated(deg_to_rad(i))
				bullet.dmg = 1
				bullet.rotation = atk_angle + deg_to_rad(i)
				bullet.d_timer = fire_lifetime
				bullet.maxd_timer = fire_lifetime
				if float(hp) / maxhp <= 0.5:
					bullet.apply_central_impulse(Vector2(fire_impulse * 0.4, 0).rotated(atk_angle))
					bullet.scale.x *= 1.2
					bullet.scale.y *= 1.2
			cooldown = 0
		7:
			# Fires a spiral of bullets
			if attack_bias - 0.05 <= float(cooldown) / max_cooldown and float(cooldown) / max_cooldown <= attack_bias:
				atk_angle = acos(sign(player.position.x - position.x))
			var bullet = preload("res://objects/enemies/enemy_3_bullet.tscn").instantiate()
			add_sibling(bullet)
			
			bullet.apply_central_impulse(
			Vector2(fire_impulse*cos(atk_angle + cooldown * PI / 25 / total_spd_m / hp * maxhp / 3)*1.1,
				fire_impulse*sin(atk_angle + cooldown * PI / 25 / total_spd_m / hp * maxhp / 3 * sign(position.x - player.position.x))*1.1))
				
			bullet.position = position
			bullet.dmg = 1
			bullet.d_timer = fire_lifetime * 0.6
			bullet.maxd_timer = fire_lifetime * 0.6
			if float(hp) / maxhp <= 0.5:
				bullet.apply_central_impulse(Vector2(fire_impulse * 0.4, 0).rotated(atk_angle))
				bullet.scale.x *= 1.2
		8:
			# Fires a sine wave of bullets
			if attack_bias - 0.05 <= float(cooldown) / max_cooldown and float(cooldown) / max_cooldown <= attack_bias:
				atk_angle = acos(sign(player.position.x - position.x))
			var bullet = preload("res://objects/enemies/enemy_3_bullet.tscn").instantiate()
			add_sibling(bullet)
			
			bullet.apply_central_impulse(
			Vector2(fire_impulse*cos(atk_angle)*0.6,
				fire_impulse*sin(atk_angle)*0.6))
				
			bullet.position = position + Vector2(0, sin(cooldown * PI / 8) * 16 - 8)
			bullet.dmg = 1
			bullet.d_timer = fire_lifetime * 0.6
			bullet.maxd_timer = fire_lifetime * 0.6
			if float(hp) / maxhp <= 0.5:
				bullet.apply_central_impulse(Vector2(fire_impulse * 0.4, 0).rotated(atk_angle))
				bullet.scale.x *= 1.2
				bullet.scale.y *= 1.2
		9:
			# Fires a tangent wave of bullets
			if attack_bias - 0.05 <= float(cooldown) / max_cooldown and float(cooldown) / max_cooldown <= attack_bias:
				atk_angle = acos(sign(player.position.x - position.x))
			var bullet = preload("res://objects/enemies/enemy_3_bullet.tscn").instantiate()
			add_sibling(bullet)
			
			bullet.apply_central_impulse(
			Vector2(fire_impulse*cos(atk_angle)*0.6,
				fire_impulse*sin(atk_angle)*0.6))
				
			bullet.position = position + Vector2(0, tan(cooldown * PI / 45 + PI / 2) * 16)
			bullet.dmg = 1
			bullet.d_timer = fire_lifetime * 0.6
			bullet.maxd_timer = fire_lifetime * 0.6
			if float(hp) / maxhp <= 0.5:
				bullet.apply_central_impulse(Vector2(fire_impulse * 0.4, 0).rotated(atk_angle))
				bullet.scale.x *= 1.2
				bullet.scale.y *= 1.2
	if cooldown == 0:
		cooldown = max_cooldown
		if m_pos == clamp(m_pos, phase_loops[0].x, phase_loops[0].y):
			atk_id = [1, 1, 1, 1, 2].pick_random()
		elif m_pos == clamp(m_pos, phase_loops[1].x, phase_loops[1].y):
			atk_id = [1, 1, 1, 2, 3].pick_random()
		elif m_pos == clamp(m_pos, phase_loops[2].x, phase_loops[2].y):
			atk_id = [1, 1, 2, 2, 6, 6, 7].pick_random()
		elif m_pos == clamp(m_pos, phase_loops[3].x, phase_loops[3].y):
			atk_id = [1, 4, 4, 5, 5, 7].pick_random()
		elif m_pos == clamp(m_pos, phase_loops[4].x, phase_loops[4].y):
			atk_id = [1, 2, 6, 7, 7, 8, 8, 9, 9].pick_random()
		elif m_pos == clamp(m_pos, phase_loops[5].x, phase_loops[5].y):
			atk_id = [1, 2, 3, 6, 7, 8, 9].pick_random()
		else:
			atk_id = [1, 2, 3].pick_random()
			cooldown *= 0.75
		
		match atk_id:
			1:
				attack_str = ">>>"
			2:
				attack_str = "mx+b"
			3:
				attack_str = "y=[m1,m2,m3,m4]x+b"
			4:
				attack_str = "x^2"
			5:
				attack_str = "x^3"
			6:
				attack_str = "x^2+y^2=r^2"
			7:
				attack_str = "(x, y)=(t*cos(t), t*sin(t))"
			8:
				attack_str = "y=sin(x)"
			9:
				attack_str = "y=tan(x)"

func _draw():
	var draw_color = Color.from_hsv(1, 1 - hp / maxhp, 1 - hp / maxhp, 1)
	draw_arc(Vector2(0, 0), 24,
	 -PI / 2, -PI / 2 + 2 * PI * hp / maxhp,
	 50, Color.DARK_RED, 6, false) # HP
	draw_arc(Vector2(0, 0), 24,
	-PI / 2 + 2 * PI * hp / maxhp - 2 * PI * dmg_effect / maxhp,
	-PI / 2 + 2 * PI * hp / maxhp,
	50, Color(1, 1, 1, 0.7), 6, false) # dmg_effect
	for i in range(-90, 250, 360 / 7):
		var notch_coords = Vector2(cos(i * PI / 180), sin(i * PI / 180))
		if float(d_timer) / maxd_timer > float(i + 90) / 360:
			draw_line(notch_coords * 21, notch_coords * 27, Color(0, 0, 0, 1), 2)
	draw_string(draw_font, Vector2(-8, -16), attack_str, HORIZONTAL_ALIGNMENT_FILL, -1, 12, 
	Color(1 - float(cooldown) / max_cooldown, 1 - float(cooldown) / max_cooldown, 1 - float(cooldown) / max_cooldown, 1))
