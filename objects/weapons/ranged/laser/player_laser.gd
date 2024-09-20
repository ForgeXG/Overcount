extends Area2D
@export var dmg : float = 1
@export var maxd_timer : float = -1
var d_timer : float = -1
var extension_speed : Vector2 = Vector2(0, 0)
var reflections : int = 0
var reflection_angle : float = 0
var hit : bool = false
var powered : bool = true

var player
var tilemap : TileMap

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	tilemap = get_tree().get_first_node_in_group("SquareTileMap")
	d_timer = maxd_timer

func _process(_delta):
	if d_timer > 0:
		d_timer -= 1
		if d_timer <= 0:
			queue_free()
	modulate.a = d_timer / maxd_timer
	
func _physics_process(_delta):
	scale += extension_speed
	for body in get_overlapping_bodies():
		if body.is_in_group("Enemies"):
			player.dps_next += dmg
			body.dmg_effect += dmg
			# var dmg_number = preload("res://ui/damage_number.tscn").instantiate()
			# get_tree().current_scene.add_child(dmg_number)
			# dmg_number.position = body.position + Vector2(randi_range(8, 24), 0).rotated(randf_range(0, TAU))
			# dmg_number.text = "%.1f" % dmg
			# player.special_charge += dmg
		elif body.is_in_group("WallTileMap") or body.is_in_group("OnOffBlock") or body.is_in_group("Filter") or body.is_in_group("Physical"):
			if body.is_in_group("OnOffBlock"):
				if body.on and extension_speed != Vector2.ZERO:
					reflect()
			elif body.is_in_group("Filter"):
				if "Laser" in body.blocked and extension_speed != Vector2.ZERO:
					reflect()
			elif extension_speed != Vector2.ZERO:
				reflect(body.rotation)
		elif body.is_in_group("OnOffSwitch"):
			for i in get_groups():
				if i in body.activation_sources and is_equal_approx(body.get_node("SwitchTimer").time_left, 0) and powered:
					# print("Switch group " + str(body.s_group) + " toggled by " + i)
					get_tree().call_group("OnOff", "switch", body.s_group)
					body.get_node("SwitchTimer").start(body.cooldown)
					powered = false
					break
			extension_speed = Vector2.ZERO


func reflect(rad_offset : float = 0.0):
	if reflections > 0 and maxd_timer - d_timer > 2:
		for i in [PI + rad_offset * 2, 2 * PI + rad_offset * 2]:
			var laser = preload("res://objects/weapons/ranged/laser/player_laser.tscn").instantiate()
			var fire_angle : float = i - rotation
			get_tree().current_scene.add_child(laser)
			laser.position = position
			laser.position += Vector2(scale.x - 4, 0).rotated(rotation) * 4
			laser.rotation = fire_angle
			laser.dmg = dmg
			laser.extension_speed.x = player.weapon.projectile_speed
			laser.reflections = reflections - 1
			laser.d_timer = player.weapon.projectile_lifetime
			laser.maxd_timer = player.weapon.projectile_lifetime
			laser.modulate = modulate
		reflections = 0
	extension_speed = Vector2.ZERO


func _on_body_entered(body):
	pass


func _on_body_exited(body):
	pass


func _on_tip_body_entered(body):
	pass


func _on_draw():
	pass
