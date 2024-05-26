extends CharacterBody2D

@export var walk_spd : int = 100
@export var jump_force : int = -200
var h_sign = 0

@export var hp : float = 2
@export var maxhp : float = 2
var dmg_effect = 0
var heal_effect = 0
var d_timer = 60

@export var min_radius : int = 8
@export var max_radius : int = 64
@export var detect_radius : int = 8

@export var dmg : int = 2

@export var score : int = 2

var player

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	player = get_parent().get_node("Player")

func _process(_delta):
	# Animations Control
	# Flip
	$Animations.flip_h = h_sign > 0
	# Speed-based animations
	if h_sign == 0:
		$Animations.animation = "idle"
	else:
		$Animations.animation = "slide"
	
	# Health Control
	if dmg_effect > 0:
		dmg_effect -= 0.1
		hp -= 0.1
		if hp <= maxhp / 2:
			scale.y = 1 / sqrt(2)
		if hp - dmg_effect <= 0:
			$Coll.set_deferred("disabled", true)
			velocity.x = -h_sign * randi_range(walk_spd * (player.mach + 3), walk_spd * (player.mach + 4)) * 0.2
			velocity.y = randi_range(-300, -500) * (player.mach + 1)
			queue_redraw()
	
	if heal_effect > 0:
		heal_effect -= 0.1
		hp -= 0.1
		
	# Death
	if hp <= 0:
		d_timer -= 1
		scale.x += 0.07
		scale.y += 0.07
		modulate.a = 0.4
		dmg = 0
	if d_timer == 0:
		player.score += score
		queue_free()

func _physics_process(delta):
	var key_jump = player.position.y < position.y - 2
	var key_accelerate = true
	var player_dist = sqrt((player.position.x - position.x) ** 2 +
	(player.position.y - position.y) ** 2)
	
	if player_dist <= max_radius and player_dist >= min_radius:
		h_sign = sign(player.position.x - position.x)
	else:
		h_sign = 0
	
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
				player.dmg_effect += dmg
				player.s_frames = 30
				player.velocity.x = -sign(position.x - player.position.x) * player.walk_spd * 0.5
				player.velocity.y = player.jump_force * 1
			if position.y < collision.get_collider().position.y:
				velocity.y = -180
	
	# Abyss Death
	if position.y > 0:
		player.score += score
		queue_free()


func _on_draw():
	var draw_color = Color(1, 0, 0, 1 - float(hp) / maxhp)
	draw_arc(Vector2(0, 0), 8,
	 -PI / 2, -PI / 2 + 2 * PI * float(hp) / maxhp,
	 7, draw_color, 4, false)
