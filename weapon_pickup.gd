extends Area2D

#class Weapon:
	#var name : String = "Dagger"
	#var type : String = "Melee" # Melee/Polynomial/Wavinator/Stringer/Projector
	#var energy_cost : int = 1
	#var cooldown : int = 20 # Frames, 1 frame = 1/60 of a second
	#var damage : float = 1.0
	#var range : float = 3 # Tiles, 1 tile = 16 pixels
	#var projectile_speed : float = 64.0 # Tiles
	#var projectile_count : int = 1
	#var projectile_lifetime : int = 120 # Frames
	#var spread : float = 0 # Radians
	#var projectile_delay : int = 0 # Frames
	#var inaccuracy : float = 0 # Radians
	#var offset : Vector2 = Vector2(0, 0)

var owned = self
var picked = false
@export var weapon : WeaponNew = WeaponNew.new()
@export var weapon_name : String = "Dagger"
@export var infinite : bool = false
var pickup_cooldown : int = 0

var player

func _ready():
	weapon = WeaponNew.create(weapon_name)
	$Animations.sprite_frames = SpriteFrames.new()
	$Sprite.texture = weapon.texture 
	player = get_tree().get_first_node_in_group("Player")

func _process(_delta):
	if pickup_cooldown > 0:
		modulate = Color.BLACK
		pickup_cooldown -= 1
	else:
		modulate = weapon.tint

func _physics_process(_delta):
	rotation += 0.01

func _on_body_entered(body):
	if owned == self and pickup_cooldown == 0:
		if body.is_in_group("Player"):
			body.weapon = weapon
			player.get_node("PlayerUI/TextCooldown").reassign()
			print("PICKED UP " + str(weapon_name).capitalize())
			if !infinite:
				queue_free()
			else:
				pickup_cooldown = 30
