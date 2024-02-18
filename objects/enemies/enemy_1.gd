extends CharacterBody2D

@export var walk_spd : int = 100
@export var jump_force : int = 0
var h_sign = 0

@export var hp : float = 1
@export var maxhp : float = 1
var dmg_effect = 0
var heal_effect = 0
var d_timer = 60

@export var min_radius : int = 8
@export var max_radius : int = 48
@export var detect_radius : int = 8

@export var dmg : int = 1

@export var score : int = 1

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
		if hp - dmg_effect <= 0:
			$Coll.set_deferred("disabled", true)
			velocity.x = -h_sign * randi_range(walk_spd * (player.mach + 3), walk_spd * (player.mach + 4))
			velocity.y = randi_range(-300, -500) * (player.mach + 1)
			
	if heal_effect > 0:
		heal_effect -= 0.1
		hp -= 0.1
		
	# Death
	if hp <= 0:
		d_timer -= 1
		scale.x += 0.03
		scale.y += 0.03
		rotation += 0.1
		modulate.a = 0.3
		dmg = 0
	if d_timer == 0:
		player.score += score
		queue_free()
	queue_redraw()

func _physics_process(delta):
	var key_jump = get_parent().get_node("Player").position.y < position.y
	var key_accelerate = true
	var player_dist = sqrt((get_parent().get_node("Player").position.x - position.x) ** 2 +
	(get_parent().get_node("Player").position.y - position.y) ** 2)
	
	if player_dist <= max_radius and player_dist >= min_radius:
		h_sign = sign(get_parent().get_node("Player").position.x - position.x)
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
				player.velocity.x = -sign(position.x - player.position.x) * player.walk_spd * 1.2
				player.velocity.y = player.jump_force * 1.2
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
	 50, draw_color, 4, false)
