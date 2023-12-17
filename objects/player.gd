extends CharacterBody2D

@export var walk_spd : int = 140
@export var jump_force : int = -300
var mach = 0
var h_sign = 0
var s_frames = 0
var j_frames = 0
var last_safe_position = Vector2(0, 0)

@export var hp : float = 30
@export var maxhp : float = 30
var dmg_effect = 0
var heal_effect = 0
var i_frames : int = 0

@export var score : int = 0
@export var maxscore : int = 500

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

var mouse_pos = Vector2(0, 0)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var cheats : bool = true

func _process(_delta):
	# Mouse
	mouse_pos = get_global_mouse_position()
	
	# Animations Control
	# Flip
	$Animations.flip_h = h_sign < 0
	# Speed-based animations
	if mach == 0:
		$Animations.animation = "idle"
	elif mach < 1:
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
	$Invincible.visible = i_frames > 0
	
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
		dmg_effect -= 0.1
		if mach < 3:
			hp -= 0.1
		if dmg_effect <= 0.05:
			dmg_effect = 0
	if heal_effect > 0:
		heal_effect -= 0.1
		hp -= 0.1
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
	if Input.is_action_just_pressed("key_cheat_next_room"):
		get_tree().change_scene_to_file(get_parent().get_node("LevelPortal").destination)
	fire_angle = atan((mouse_pos.y - position.y) / (mouse_pos.x - position.x))
	if mouse_pos.x - position.x < 0:
		fire_angle -= PI
	queue_redraw()

func _physics_process(delta):
	var key_left = Input.is_action_pressed("key_a")
	var key_right = Input.is_action_pressed("key_d")
	var key_jump = Input.is_action_pressed("key_w")
	var key_accelerate = Input.is_action_pressed("key_acceleration")
	if s_frames > 0:
		key_left = false
		key_right = false
		key_jump = false
		key_accelerate = false
	
	h_sign = int(key_right) - int(key_left)
	if h_sign != 0:
		if key_accelerate:
			if !is_on_wall():
				mach = clamp(mach, 1, 3)
				mach += 0.01
		elif !is_on_wall() and mach < 0.6:
			mach += 0.01
	else:
		mach = clamp(mach, 0, 2)
		mach -= 0.2
	mach = clamp(mach, 0, 3)
	
	# Gravity and Last Safe Position
	if not is_on_floor():
		velocity.y += gravity * delta
		if j_frames > 0:
			j_frames -= 1
	else:
		j_frames = 10 # Standard 1/4 s
		last_safe_position = position

	# Handle Jump.
	if key_jump:
		if is_on_floor() or j_frames > 0:
			velocity.y = jump_force
			j_frames = -1
			if mach == 3:
				velocity.y *= 1.5
		elif is_on_wall() and mach >= 1:
			velocity.y = jump_force * 0.75
			mach = clamp(mach, 0, 2)

	if s_frames == 0:
		velocity.x = h_sign * walk_spd * (clamp(mach, 0, 3) / 2 + 1)

	move_and_slide()
	
	# Restart.
	if position.y > 0:
		position = last_safe_position
		dmg_effect += 5
		
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var coll = collision.get_collider()
		if mach == 3:
			if coll.is_in_group("Enemies"):
				coll.dmg_effect += 1
				coll.d_timer -= 10
		if coll.is_in_group("HazardSpike"):
			if i_frames == 0:
				dmg_effect += 2
				i_frames = 90
				s_frames = 45
				velocity.x = -h_sign * walk_spd * 1.2
				velocity.y = jump_force * 1.2

func attack():
	if energy >= energy_use and cooldown == 0:
		energy -= energy_use
		cooldown = cooldown_use
		if weapon_type == "Melee":
			var poke = preload("res://m_poke.tscn").instantiate()
			add_child(poke)
			poke.modulate = get_node(weapon_filename).modulate
			poke.dmg = randf_range(mindmg, maxdmg)
			poke.position += weapon_tip
			poke.rotation = get_child(-2).rotation
			poke.scale.x = 3
			poke.scale.y = 1
		elif weapon_type == "Sling":
			if weapon_name == "ParabolicSling":
				var bullet = preload("res://objects/weapons/ranged/bullet/player_bullet.tscn").instantiate()
				get_tree().current_scene.add_child(bullet)
				bullet.position = position
				bullet.position += Vector2(2, 0).rotated(fire_angle)
				bullet.modulate = get_node(weapon_filename).modulate
				bullet.dmg = randf_range(mindmg, maxdmg)
				bullet.apply_central_impulse(Vector2(fire_speed * cos(fire_angle), fire_speed * sin(fire_angle)))
				bullet.d_timer = 120
				bullet.maxd_timer = 120

func _on_draw():
	if weapon_type == "Sling":
		if weapon_name == "ParabolicSling": 
			if mouse_pos.x >= position.x:
				for i in range(0, 256, 1):
					draw_line(Vector2(i, p_traj(i)), Vector2(i + 1, p_traj(i + 1)), Color(0, 0, 1, 0.6), 2)
			else:
				for i in range(-256, 0, 1):
					draw_line(Vector2(i, p_traj(i)), Vector2(i + 1, p_traj(i + 1)), Color(0, 0, 1, 0.6), 2)

func p_traj(a):
	return (tan(fire_angle) * a) + ((gravity * (a * a)) / (2 * (fire_speed * fire_speed) * cos(fire_angle) * cos(fire_angle)))
