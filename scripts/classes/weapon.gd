extends Resource

class_name WeaponNew

var weapon_name : String = "Dagger"
var texture : CompressedTexture2D = preload("res://sprites/weapons/melee/s_dagger.png")
var type : String = "Melee" # Melee/Linear/Polynomial/Wavinator/Stringer/Projector
var energy_cost : int = 5
var cooldown : int = 20 # Frames, 1 frame = 1/60 of a second
var damage : float = 1.5
var radius : float = 3 # Tiles, 1 tile = 16 pixels
var projectile_speed : float = 64.0 # Tiles
var projectile_count : int = 1
var projectile_lifetime : int = 120 # Frames
var spread : float = 0 # Radians
var projectile_delay : int = 0 # Frames
var inaccuracy : float = PI / 9 # Radians
var offset : Vector2 = Vector2(0, 0)
var tip : Vector2 = Vector2(8, 2)
var tint : Color = Color.WHITE
var sub_weapon : String = "None"
var special_weapon : String = "Bullet Line"
var special_points : float = 50.0
var extra : Array = [0, 0]

static func create(weapon_name : String) -> WeaponNew:
	var w : WeaponNew = WeaponNew.new() # Creates a weapon and assigns arguments to it
	w.weapon_name = weapon_name
	match weapon_name:
		"Empty":
			w.texture = preload("res://ui/ui_sprites/particle_shapes/Pixel.png")
			w.type = "None"
			w.energy_cost = 0
			w.cooldown = 0
			w.damage = 0
			w.radius = 3
			w.projectile_speed = 64.0; w.projectile_count = 1; w.projectile_lifetime = 120
			w.spread = 0
			w.projectile_delay = 0
			w.inaccuracy = PI / 9
			w.special_weapon = "Bullet Line"
			w.special_points = 50.0
			w.offset = Vector2(0, 0)
			w.tip = Vector2(8, 2)
		"Dagger":
			w.texture = preload("res://sprites/weapons/melee/s_dagger.png")
			w.type = "Melee"
			w.energy_cost = 5
			w.cooldown = 20
			w.damage = 1.5
			w.radius = 3
			w.projectile_speed = 64.0; w.projectile_count = 1; w.projectile_lifetime = 120
			w.spread = 0
			w.projectile_delay = 0
			w.inaccuracy = PI / 9
			w.special_weapon = "Bullet Line"
			w.special_points = 50.0
			w.offset = Vector2(0, 0)
			w.tip = Vector2(8, 2)
		"WellDef Dagger":
			w.texture = preload("res://sprites/weapons/melee/s_dagger.png")
			w.type = "Melee"
			w.energy_cost = 7
			w.cooldown = 30
			w.damage = 1.4
			w.radius = 6
			w.projectile_speed = 64.0; w.projectile_count = 1; w.projectile_lifetime = 120
			w.spread = 0
			w.projectile_delay = 0
			w.inaccuracy = PI / 15
			w.special_points = 60.0
			w.offset = Vector2(0, 0)
			w.tip = Vector2(8, 2)
			w.tint = Color.CORAL
		"Deco Dagger":
			w.texture = preload("res://sprites/weapons/melee/s_dagger.png")
			w.type = "Melee"
			w.energy_cost = 7
			w.cooldown = 30
			w.damage = 3.0
			w.radius = 4
			w.projectile_speed = 64.0; w.projectile_count = 1; w.projectile_lifetime = 120
			w.spread = 0
			w.projectile_delay = 0
			w.inaccuracy = PI / 6
			w.special_points = 60.0
			w.offset = Vector2(0, 0)
			w.tip = Vector2(8, 2)
			w.tint = Color.DARK_ORANGE
		"Angleshot":
			w.texture = preload("res://sprites/weapons/linear/angleshot/AngleShot.png")
			w.type = "Linear"
			w.energy_cost = 10
			w.cooldown = 20
			w.damage = 0.05
			w.radius = 4
			w.projectile_speed = 2.0; w.projectile_count = 1; w.projectile_lifetime = 60
			w.spread = 0
			w.projectile_delay = 0
			w.inaccuracy = 0
			w.special_points = 100.0
			w.offset = Vector2(0, 0)
			w.tip = Vector2(8, 2)
			w.tint = Color.WHITE
			w.extra[0] = 3
		"Thrangleshot":
			w.texture = preload("res://sprites/weapons/linear/angleshot/AngleShot.png")
			w.type = "Linear"
			w.energy_cost = 15
			w.cooldown = 30
			w.damage = 0.04
			w.radius = 4
			w.projectile_speed = 1.5; w.projectile_count = 3; w.projectile_lifetime = 30
			w.spread = PI / 9
			w.projectile_delay = 0
			w.inaccuracy = 0
			w.special_points = 120.0
			w.offset = Vector2(0, 0)
			w.tip = Vector2(8, 2)
			w.tint = Color.DARK_ORANGE
			w.extra[0] = 1
		"ParabolicSling":
			w.texture = preload("res://sprites/weapons/polynomials/parabolicsling/sling/QuadraticSling.png")
			w.type = "Polynomial"
			w.energy_cost = 5
			w.cooldown = 15
			w.damage = 1.0
			w.radius = 3
			w.projectile_speed = 500.0
			w.projectile_count = 1
			w.projectile_lifetime = 120
			w.spread = 0
			w.projectile_delay = 0
			w.inaccuracy = 0
			w.special_points = 80.0
			w.offset = Vector2(0, 0)
			w.tip = Vector2(8, 0)
			w.extra = [0, 0]
		"CubicSling":
			w.texture = preload("res://sprites/weapons/polynomials/cubicsling/sling/CubicSling.png")
			w.type = "Polynomial"
			w.energy_cost = 8
			w.cooldown = 20
			w.damage = 2.5
			w.radius = 3
			w.projectile_speed = 400.0
			w.projectile_count = 1
			w.projectile_lifetime = 180
			w.spread = 0
			w.projectile_delay = 0
			w.inaccuracy = 0
			w.special_weapon = "Bullet Line"
			w.special_points = 100.0
			w.offset = Vector2(0, 0)
			w.tip = Vector2(8, 0)
			w.extra = [-0.02, 0]
		"QuarticSling":
			w.texture = preload("res://sprites/weapons/polynomials/quarticsling/sling/QuarticSling.png")
			w.type = "Polynomial"
			w.energy_cost = 10
			w.cooldown = 30
			w.damage = 4.0
			w.radius = 3
			w.projectile_speed = 300.0
			w.projectile_count = 1
			w.projectile_lifetime = 240
			w.spread = 0
			w.projectile_delay = 0
			w.inaccuracy = 0
			w.special_points = 120.0
			w.offset = Vector2(0, 0)
			w.tip = Vector2(8, 0)
			w.extra = [-0.05, 0.001]
	return w
