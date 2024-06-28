extends CharacterBody2D

# Movement
@export var draw_font : SystemFont

@export var walk_spd : int = 140
@export var jump_force : int = -300

var autorun : bool = false

@export var y_death : float = 0
var mach = 0
var int_mach : int = 0
var h_sign = 0
var s_frames = 0
var j_frames = 0
var last_safe_position = Vector2.ZERO

var kicked : bool = false

# Checkpoints
@export var keep_music_position : bool = true
var checkpoint_position : Vector2 = Vector2.ZERO
var checkpoint_music_position : float = 0
var checkpoint_camera_position : Vector2 = Vector2.ZERO
var checkpoint_camera_timeline : float = 0
var checkpoint_camera_zoom : Vector2 = Vector2.ZERO

# Health
@export var hp : float = 30
@export var maxhp : float = 30
var dmg_effect = 0
var heal_effect = 0
var i_frames : int = 0

# Effects
@export var status_effects : Array[String] = []

# Score
@export var score : int = 0
@export var maxscore : int = 500

# Speedrunning
var speedrun_time : float = 0
@export var escape_time : int = -1
@export var escape_time_active : bool = false

# Weapon variables
var energy = 100
@export var maxenergy : int = 100
var cooldown = 0

var has_weapon = false
var weapon_name = "None"
var weapon_filename : NodePath = "None"
var weapon_type = "None"
var energy_use = 0
var cooldown_use = 0
var mindmg = 0
var maxdmg = 0
var weapon_rot = 0
var weapon_tip = Vector2(0, 0)
var fire_speed = 0
var fire_angle = 0

var mouse_pos = Vector2.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var gravity : float = 980.0

@export var cheats : bool = true

func _ready():
	checkpoint_position = position
	if get_parent().get_node_or_null("Camera") != null:
		checkpoint_camera_position = get_parent().get_node_or_null("Camera").position
		checkpoint_camera_zoom = get_parent().get_node_or_null("Camera").zoom

func _process(delta):
	# Mouse
	mouse_pos = get_global_mouse_position()
	int_mach = int(mach * 100)

	# Animations Control
	# Flip
	# $Animations.flip_h = h_sign < 0
	# Gravity
	$Animations.flip_v = gravity < 0
	up_direction.y = -sign(gravity + 0.001)
	# Speed-based animations
	if kicked:
		$Animations.animation = "kickballs"
	elif mach == 0:
		$Animations.animation = "idle"
	else:
		if mach < 1:
			$Animations.animation = "walk"
		elif is_on_wall() and mach >= 1:
			$Animations.animation = "wallclimb"
		elif mach < 2:
			$Animations.animation = "run1"
		elif mach < 3:
			$Animations.animation = "run2"
		else:
			$Animations.animation = "run3"
	
	# Invincible animation
	if i_frames > 0:
		$Animations.material = load("res://materials/player/player_invincible.tres")
	else:
		$Animations.material = load("res://materials/player/player_default.tres")
	
	# Attacking
	if Input.is_action_pressed("mouse_attack") and weapon_name != "None":
		attack()
	
	if cooldown > 0:
		cooldown -= 1
	
	if has_weapon:
		weapon_rot = get_node(weapon_filename).rotation
		weapon_tip = Vector2(12*cos(weapon_rot), 12*sin(weapon_rot)) + Vector2(0, 3)
	
	# Health Control
	if dmg_effect > 0:
		if mach < 3:
			hp -= dmg_effect * 0.1
		dmg_effect *= 0.9
		if dmg_effect <= 0.001:
			dmg_effect = 0
	if heal_effect > 0 and hp < maxhp:
		heal_effect -= 0.1
		hp += 0.1
	if i_frames > 0:
		i_frames -= 1
	if s_frames > 0:
		s_frames -= 1
	
	dmg_effect = clamp(dmg_effect, 0, 10**10)
	heal_effect = clamp(heal_effect, 0, 10**10)
	
	# Energy Control
	if energy > maxenergy:
		energy = maxenergy
	
	# Score Control
	if score > maxscore:
		score = maxscore
	
	# Death
	if hp <= 0:
		get_tree().reload_current_scene()
		
	# Timer
	if escape_time_active:
		if escape_time == 0:
			get_tree().reload_current_scene()
		elif escape_time > 0:
			escape_time -= 1
			$PlayerUI/TextTimer.text = str(escape_time / 3600) + ":" + str(escape_time % 3600 / 60)
			$PlayerUI/ImageTimer.visible = true
			$PlayerUI/ImageTimer.texture.pause = false
 
	# Restarting
	if Input.is_action_just_pressed("key_restart"):
		get_tree().reload_current_scene()
		
	# Cheats
	if G.enable_cheats:
		if Input.is_action_just_pressed("key_cheat_next_room"):
			get_tree().change_scene_to_file(get_parent().get_node("LevelPortal").destination)
	fire_angle = atan((mouse_pos.y - position.y) / (mouse_pos.x - position.x))
	if mouse_pos.x - position.x < 0:
		fire_angle -= PI
		
	speedrun_time += 60 * delta
	queue_redraw()

func _physics_process(delta):
	var key_left : bool = Input.is_action_pressed("key_a")
	var key_right : bool = Input.is_action_pressed("key_d")
	var key_jump : bool = Input.is_action_pressed("key_w")
	var key_autorun : bool = Input.is_action_just_pressed("key_autorun")
	var key_accelerate : bool = Input.is_action_pressed("key_acceleration") or autorun
	var key_ability : bool = Input.is_action_just_pressed("key_ability")
	var key_checkpoint : bool = Input.is_action_just_pressed("key_checkpoint")
	
	var key_parry : bool = Input.is_action_just_pressed("key_parry")
	var key_kick : bool = Input.is_action_just_pressed("key_kick")
	
	if key_autorun:
		autorun = !autorun
	
	if key_parry and i_frames <= 0 and s_frames <= 0:
		i_frames = 10
		s_frames = 10

	if key_left:
		$Animations.flip_h = true
	if key_right:
		$Animations.flip_h = false
	
	if key_kick and s_frames <= 0:
		s_frames = 20
		kicked = true
		get_tree().call_group("PiBall", "yeet", Vector2(320, 0).rotated(fire_angle))
		mach = 0
	
	if s_frames > 0:
		key_left = false
		key_right = false
		key_accelerate = false
	else:
		kicked = false
	
	h_sign = int(key_right) - int(key_left)
	
	# Reversed status effect
	if "Reversed" in status_effects:
		h_sign *= -1
	
	if h_sign != 0:
		if key_accelerate:
			if !is_on_wall():
				mach = clamp(mach, 1, 3)
				mach += 0.01
		elif !is_on_wall() and mach < 0.6:
			mach += 0.01
	elif s_frames == 0:
		mach = clamp(mach, 0, 2)
		mach -= 0.2
	mach = clamp(mach, 0, 3)
	
	# Gravity and Last Safe Position
	if not is_on_floor():
		velocity.y += gravity * delta
		if j_frames > 0:
			j_frames -= 1
	else:
		j_frames = 10 # Standard 1/6 s

	# Handle Jump.
	if key_jump:
		if is_on_floor() or j_frames > 0:
			velocity.y = jump_force * delta * 60 * -up_direction.y
			j_frames = -1
			if mach == 3:
				velocity.y *= 1.5
		elif is_on_wall() and mach >= 1:
			velocity.y = jump_force * 0.9 * delta * 60 * -up_direction.y
			mach = clamp(mach, 0, 2)

	if s_frames == 0:
		velocity.x = h_sign * walk_spd * (clamp(mach, 0, 3) / 2 + 1) * delta * 60

	move_and_slide()
	
	# Ability
	if key_ability:
		ability(10)
	
	# Void trigger load.
	if position.y > y_death or key_checkpoint:
		position = checkpoint_position
		if !keep_music_position:
			get_parent().get_node("MusicPlayer").play(checkpoint_music_position)
		dmg_effect += 5
		if get_parent().get_node_or_null("Camera") != null:
			get_parent().get_node_or_null("Camera").position_smoothing_speed = 1000
			get_parent().get_node_or_null("Camera").position = checkpoint_camera_position
			get_parent().get_node_or_null("Camera").m_timer = checkpoint_camera_timeline
			# get_parent().get_node("Camera").zoom = checkpoint_camera_zoom
			get_parent().get_node_or_null("Camera").apply_stats()
			
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var coll = collision.get_collider()
		if mach == 3:
			if coll.is_in_group("Enemies"):
				coll.dmg_effect += 1
				coll.d_timer -= 10
		if coll.is_in_group("Hazard"):
			if coll.is_in_group("HazardMelee"):
				if i_frames == 0:
					damage(3)
					i_frames = 90
					s_frames = 45
					velocity.x = -h_sign * walk_spd * 1.2 * delta * 60
					velocity.y = jump_force * 1.2 * delta * 60 * -up_direction.y
					if coll.is_in_group("HazardSaw"):
						velocity.x = -h_sign * walk_spd * 1.6 * delta * 60
						damage(8)
		elif coll.is_in_group("WallTileMap") and is_on_floor():
			last_safe_position = position

func attack():
	if energy >= energy_use and cooldown == 0:
		energy -= energy_use
		cooldown = cooldown_use
		if weapon_type == "Melee":
			var poke : Node = preload("res://m_poke.tscn").instantiate()
			add_child(poke)
			if get_node(weapon_filename) != null:
				poke.modulate = get_node(weapon_filename).modulate
			poke.dmg = randf_range(mindmg, maxdmg)
			poke.position += weapon_tip
			poke.rotation = fire_angle
			poke.scale.x = 3
			poke.scale.y = 1
		elif weapon_type == "Sling":
			if weapon_name == "ParabolicSling":
				var bullet = preload("res://objects/weapons/ranged/bullet/player_bullet.tscn").instantiate()
				get_tree().current_scene.add_child(bullet)
				bullet.position = position
				bullet.position += Vector2(2, 0).rotated(fire_angle)
				# bullet.modulate = get_node(weapon_filename).modulate
				bullet.modulate = modulate
				bullet.dmg = randf_range(mindmg, maxdmg)
				bullet.apply_central_impulse(Vector2(fire_speed * cos(fire_angle), fire_speed * sin(fire_angle)))
				bullet.d_timer = 120
				bullet.maxd_timer = 120

func ability(ability_cost : int):
	if energy >= ability_cost:
		energy -= ability_cost
		# Bullet Line
		for i in range(10):
			var bullet = preload("res://objects/weapons/ranged/bullet/player_bullet.tscn").instantiate()
			get_tree().current_scene.add_child(bullet)
			bullet.position = position
			bullet.position += Vector2(i, 0).rotated(fire_angle)
			bullet.apply_scale(Vector2(1.3, 1.3))
			bullet.modulate = Color(0, 0, 1, 1)
			bullet.dmg = 2
			bullet.gravity_scale = 0
			bullet.apply_central_impulse(Vector2(50 * i * cos(fire_angle), 50 * i * sin(fire_angle)))
			bullet.d_timer = 300
			bullet.maxd_timer = 300
		cooldown = 60

func _on_draw():
	# draw_string(draw_font, Vector2(0, -16), $Animations.animation, HORIZONTAL_ALIGNMENT_FILL, -1, 12, 
	#	Color.WHITE)
	draw_line(Vector2.ZERO, Vector2(64, 0).rotated(fire_angle), Color(0, 0, 1, 0.3), 2, false)
	
	if weapon_type == "Sling":
		if weapon_name == "ParabolicSling":
			if mouse_pos.x >= position.x:
				for i in range(0, 256, 1):
					draw_line(Vector2(i, p_traj(i)), Vector2(i + 1, p_traj(i + 1)), Color(0, 0, 1, 0.6), 2)
			else:
				for i in range(-256, 0, 1):
					draw_line(Vector2(i, p_traj(i)), Vector2(i + 1, p_traj(i + 1)), Color(0, 0, 1, 0.6), 2)
	
	draw_line(Vector2.ZERO, velocity / 4.0, 
	Color.from_hsv(velocity.length() / 500.0, 1, 1, 0.8), 2, false)

func p_traj(a):
	return (tan(fire_angle) * a) + ((gravity * (a * a)) / (2 * (fire_speed * fire_speed) * cos(fire_angle) * cos(fire_angle)))

# Player Methods
func damage(a : float, is_instant : bool = false):
	print("DAMAGED")
	if !is_instant:
		dmg_effect += a
	else:
		hp -= a

func heal(a : float, is_instant : bool = false):
	if !is_instant:
		heal_effect += a
	else:
		hp += a
