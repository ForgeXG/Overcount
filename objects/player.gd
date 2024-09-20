extends CharacterBody2D

# OOP (Player and Weapon)
class_name Player

var debug_float : float = 0.0

# Movement
@export var draw_font : SystemFont
@export var material_changing : bool = true

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
# Boolean
# Reversed - Horizontal controls are inverted.
# Solving - Completely invulnerable, unable to attack and horizontally static.
# Anticlimb - Cannot get up walls.
# Jumphobia - Only jumps when getting off a ledge.
# Y-negative - Cannot jump OR climb.
# Continuous
# Resistance - Subtracts less hp per damage
# Quickdraw - Weapon cooldown is lowered.
# Efficiency - Spends less energy per attack.
# Supercharge - Special weapon takes less time/damage to charge up.
# Math-aid - Math problems recover more hp.

# Score
@export var score : int:
	set(value):
		score = clamp(value, 0, INF)

@export var maxscore : int = 500

# Speedrunning
var speedrun_time : float = 0
@export var escape_time : int = -1
@export var escape_time_active : bool = false

# Weapon class (Current)
var weapon : WeaponNew = WeaponNew.new()
# Weapon variables (Legacy)
var energy = 100
@export var maxenergy : int = 100
var cooldown = 0
var special_charge : float = 0: # Max is 100
	set(value):
		special_charge = clamp(value, 0, weapon.special_points)

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
var dps : float = 0
var dps_next : float = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var gravity : float = 980.0

class Phrase:
	var characters : Array[String] = ["Alpha", "Beta", "Zeta", "Sigma"]
	var char_sprites : Array[Resource] = [load("res://ui/ui_sprites/dialogue/alpha/DialogueAlpha.png"),
	load("res://ui/ui_sprites/dialogue/alpha/DialogueAlpha.png"),
	load("res://ui/ui_sprites/dialogue/zeta/DialogueZeta.png"),
	load("res://ui/ui_sprites/dialogue/sigma/DialogueSigma.png")]
	var text : String = ""
	var char_ind : int = 0
	static func create_phrase(text : String = "", char_ind : int = 0):
		var p = Phrase.new()
		p.text = text
		p.char_ind = char_ind
		print("Created new Phrase!")
		return p
	
class Dialogue:
	var phrases : Array[Phrase] = [Phrase.create_phrase()]
	var phrase_ind : int = 0

var dialogue = Dialogue.new()
@export var cheats : bool = true

func _ready():
	checkpoint_position = position
	if get_parent().get_node_or_null("Camera") != null:
		checkpoint_camera_position = get_parent().get_node_or_null("Camera").position
		checkpoint_camera_zoom = get_parent().get_node_or_null("Camera").zoom

func _process(delta):
	if Input.is_key_pressed(KEY_4):
		debug_float *= 1.1
	elif Input.is_key_pressed(KEY_5):
		debug_float /= 1.1
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
			$GPUPart.process_material = preload("res://sprites/player/particles/playerwalk.tres")
		elif is_on_wall() and mach >= 1:
			$Animations.animation = "wallclimb"
			$GPUPart.process_material = preload("res://sprites/player/particles/playerrun1.tres")
		elif mach < 2:
			$Animations.animation = "run1"
			$GPUPart.process_material = preload("res://sprites/player/particles/playerrun1.tres")
		elif mach < 3:
			$Animations.animation = "run2"
			$GPUPart.process_material = preload("res://sprites/player/particles/playerrun2.tres")
		else:
			$Animations.animation = "run3"
			$GPUPart.process_material = preload("res://sprites/player/particles/playerrun3.tres")
	
	# Invincible animation
	if material_changing:
		$Animations.use_parent_material = false
		if i_frames > 0:
			$Animations.material = load("res://materials/player/player_invincible.tres")
		else:
			$Animations.material = load("res://materials/player/player_default.tres")
	else:
		$Animations.material = material
	# Attacking
	$WeaponSprite.rotation = fire_angle
	if Input.is_action_pressed("mouse_attack") and weapon_name != "":
		attacknew()
	
	if cooldown > 0:
		cooldown -= 1
	
	# Weapon
	$WeaponSprite.texture = weapon.texture
	$WeaponSprite.modulate = weapon.tint
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
	if dmg_effect == 0 and cooldown == 0:
		energy += 1
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
			if $PlayerUI/TextTimer.text != "GG":
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
		if Input.is_action_pressed("key_cheat_give_energy") and energy < maxenergy:
			energy += 1
		if Input.is_action_just_pressed("key_instant_charge"):
			special_charge = weapon.special_points
	fire_angle = atan((mouse_pos.y - position.y) / (mouse_pos.x - position.x))
	if mouse_pos.x - position.x < 0:
		fire_angle -= PI
	
	if $PlayerUI/TextTimer.text != "GG":
		speedrun_time += 60 * delta
	
	# Dialogue
	if Input.is_action_just_pressed("key_phrase_next") and dialogue.phrase_ind < dialogue.phrases.size() - 1:
		dialogue.phrase_ind += 1
	elif Input.is_action_just_pressed("key_phrase_previous") and dialogue.phrase_ind > 0:
		dialogue.phrase_ind -= 1
	
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
	
	var key_exchange_energy = Input.is_action_pressed("key_exchange_energy")
	
	if key_exchange_energy:
		if energy < maxenergy:
			dmg_effect += 1
			energy += 1
	
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
	if "Solving" in status_effects:
		h_sign = 0
	
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
			$PlayerAnim.play("jump")
		elif is_on_wall() and mach >= 1:
			var last_coll = get_last_slide_collision().get_collider()
			if last_coll.is_in_group("WallTileMap") or last_coll.is_in_group("OnOff"):
				velocity.y = jump_force * 0.9 * delta * 60 * -up_direction.y
				mach = clamp(mach, 0, 2)

	if s_frames == 0:
		velocity.x = h_sign * walk_spd * (clamp(mach, 0, 3) / 2 + 1) * delta * 60

	move_and_slide()
	
	# Ability
	if key_ability and special_charge >= weapon.special_points:
		ability(weapon.special_points)
	
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
		elif coll.is_in_group("Physical"):
			print("PHYSICAL COLLISION")
			# coll.apply_force(Vector2(velocity.x * 100, 0))

func attacknew(): # Current
	if energy >= weapon.energy_cost and cooldown == 0:
		# print("ENERGY CHECKED")
		$WeaponSprite/WeaponAnim.play("attack", -1, 90.0 / weapon.cooldown)
		energy -= weapon.energy_cost
		cooldown = weapon.cooldown
		randomize()
		var inacc : float = randf_range(-weapon.inaccuracy, weapon.inaccuracy)
		if weapon.type == "Melee":
			var poke : Node = preload("res://m_poke.tscn").instantiate()
			add_child(poke)
			poke.dmg = weapon.damage
			poke.position += weapon.tip.rotated(fire_angle + inacc)
			poke.rotation = fire_angle + inacc
			poke.scale.x *= weapon.radius
			poke.modulate = weapon.tint
		elif weapon.type == "Polynomial":
			var bullet = preload("res://objects/weapons/ranged/bullet/player_bullet.tscn").instantiate()
			get_tree().current_scene.add_child(bullet)
			bullet.position = position
			bullet.position += Vector2(2, 0).rotated(fire_angle + inacc)
			bullet.dmg = weapon.damage
			bullet.apply_central_impulse(weapon.projectile_speed * Vector2(cos(fire_angle + inacc),
			sin(fire_angle + inacc)))
			bullet.d_timer = weapon.projectile_lifetime
			bullet.maxd_timer = weapon.projectile_lifetime
			bullet.modulate = weapon.tint
			bullet.derivatives[0] = weapon.extra[0]
			bullet.derivatives[1] = weapon.extra[1]
		elif weapon.type == "Linear":
			if weapon.weapon_name == "Angleshot" or weapon.weapon_name == "Thrangleshot":
				var begin : float = -(weapon.spread / 2) if weapon.projectile_count != 1 else 0
				var end : float = (weapon.spread / 2) if weapon.projectile_count != 1 else 1
				var step : float = (end * 2 / (weapon.projectile_count - 1)) if weapon.projectile_count != 1 else 1
				print(begin, end, step)
				for i in range(rad_to_deg(begin), rad_to_deg(end) + 1 if begin != 0 else 1, rad_to_deg(step)):
					var laser = preload("res://objects/weapons/ranged/laser/player_laser.tscn").instantiate()
					get_tree().current_scene.add_child(laser)
					laser.position = position
					laser.position += Vector2(2, 0).rotated(fire_angle + inacc)
					laser.rotation = fire_angle + deg_to_rad(i) + inacc
					laser.dmg = weapon.damage
					laser.extension_speed.x = weapon.projectile_speed
					laser.reflections = weapon.extra[0]
					laser.d_timer = weapon.projectile_lifetime
					laser.maxd_timer = weapon.projectile_lifetime
					laser.modulate = weapon.tint
					# if weapon.projectile_count == 1:
						# laser.rotation -= i
						# break

func attack(): # Deprecated
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

func ability(ability_cost : float = weapon.special_points):
	if weapon.special_weapon != "None":
		print("SPECIAL ATTACK")
		special_charge -= ability_cost
		# Bullet Line
		if weapon.special_weapon == "Bullet Line":
			for i in range(25):
				var bullet = preload("res://objects/weapons/ranged/bullet/player_bullet.tscn").instantiate()
				get_tree().current_scene.add_child(bullet)
				bullet.position = position
				bullet.position += Vector2(i, 0).rotated(fire_angle)
				bullet.apply_scale(Vector2(1.5, 1.5))
				bullet.modulate = Color(0, 0, 1, 1)
				bullet.dmg = 2
				bullet.gravity_scale = 0
				bullet.apply_central_impulse(Vector2(10 * i * cos(fire_angle), 10 * i * sin(fire_angle)))
				bullet.d_timer = 300
				bullet.maxd_timer = 300
			cooldown = 60

func _on_draw():
	draw_set_transform(Vector2(0, 2))
	draw_line(Vector2.ZERO, Vector2(64, 0).rotated(fire_angle), Color(0, 0, 1, 0.3), 2, false)
	draw_arc(Vector2.ZERO, 16, fire_angle - weapon.inaccuracy, fire_angle + weapon.inaccuracy, 15, Color.ORANGE_RED, 2, false)
	draw_set_transform(Vector2.ZERO)
	if weapon.type == "Polynomial":
		if mouse_pos.x >= position.x:
			for i in range(0, 320, 1):
				draw_line(Vector2(i, p_traj(i, gravity, weapon.extra[0], weapon.extra[1])),
				Vector2(i + 1, p_traj(i + 1, gravity, weapon.extra[0], weapon.extra[1])), Color(0, 0, 1, 0.5), 2)
		else:
			for i in range(-320, 0, 1):
				draw_line(Vector2(i, p_traj(i, gravity, weapon.extra[0], weapon.extra[1])),
				Vector2(i + 1, p_traj(i + 1, gravity, weapon.extra[0], weapon.extra[1])), Color(0, 0, 1, 0.5), 2)
	
	draw_line(Vector2.ZERO, velocity / 4.0, 
	Color.from_hsv(velocity.length() / 500.0, 1, 1, 0.8), 2, false)

# Projectile Trajectory (g = gravity, j = Jolt, s = Snap)
func p_traj(x : float, g : float, j : float = 0.0, s : float = 0.0) -> float:
	var v : float = weapon.projectile_speed
	var initial : float = (tan(fire_angle) * x) + (g * x * x) / (2 * v * v * pow(cos(fire_angle), 2))
	var jerk : float = (j * pow(x, 3)) / (6 * pow(v, 3) * pow(cos(fire_angle), 3)) * 60000
	var snap : float = (s * pow(x, 4)) / (24 * pow(v, 4) * pow(cos(fire_angle), 4)) * 3600000
	return initial + jerk + snap


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


func _on_timer_timeout():
	dps = dps_next
	dps_next = 0
