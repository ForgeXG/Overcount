extends Area2D

var owned = self
var picked = false
@export var weapon_name : String = "Dagger"
@export var weapon_type : String = "Melee"
@export var energy_use : int = 0
@export var cooldown_use : int = 30
@export var mindmg : int = 1
@export var maxdmg : int = 1
@export var fire_speed : int = 0

func _ready():
	if weapon_type == "Sling":
		if weapon_name == "ParabolicSling":
			$Animations.sprite_frames = load("res://sprites/weapons/ranged/parabolicsling/sling/ps_frames.tres")

func _process(_delta):
	if owned != self and !picked:
		get_parent().remove_child(self)
		owned.add_child(self)
		owned.has_weapon = true
		picked = true

func _physics_process(_delta):
	var mouse_pos = get_global_mouse_position()
	if owned != self:
		var level = get_tree().current_scene
		position = Vector2(0, 3)
		
		rotation = Vector2(mouse_pos.x - global_position.x,
		mouse_pos.y - global_position.y).angle()
	else:
		rotation += 0.01

func _on_body_entered(body):
	if owned == self:
		if body.is_in_group("Player"):
			if body.weapon_name != "None":
				body.get_node(body.weapon_filename).queue_free()
				body.has_weapon = false
			body.weapon_filename = name
			owned = body
			owned.weapon_name = weapon_name
			owned.weapon_type = weapon_type
			owned.energy_use = energy_use
			owned.cooldown_use = cooldown_use
			owned.mindmg = mindmg
			owned.maxdmg = maxdmg
			owned.fire_speed = fire_speed
			owned.get_node("PlayerUI").get_node("TextCooldown").maxval = cooldown_use
			print("PICKED UP " + str(weapon_name).capitalize())
