extends RigidBody2D
@export var dmg : float = 1
@export var maxd_timer : float = -1
var d_timer : float = -1
var derivatives : Array[float] = [0, 0] # Jolt(3rd order), Snap(4th order)

var player

func _ready():
	d_timer = maxd_timer
	player = get_tree().get_first_node_in_group("Player")

func _process(_delta):
	if d_timer > 0:
		d_timer -= 1
		if d_timer <= 0:
			queue_free()
	modulate.a = d_timer / maxd_timer
	
func _physics_process(_delta):
	gravity_scale += derivatives[0] # Jolt
	derivatives[0] += derivatives[1] # Snap

func _on_body_entered(body):
	if !body.is_in_group("Player"):
		linear_velocity = Vector2.ZERO
		gravity_scale = 0
		derivatives[0] = 0
		derivatives[1] = 0
	if body.is_in_group("OnOffSwitch"):
		queue_free()
	if body.is_in_group("Enemies"):
		player.dps_next += dmg
		position.y -= 16
		body.dmg_effect += dmg
		var dmg_number = preload("res://ui/damage_number.tscn").instantiate()
		get_tree().current_scene.add_child(dmg_number)
		dmg_number.position = body.position + Vector2(randi_range(8, 24), 0).rotated(randf_range(0, TAU))
		dmg_number.text = "%.1f" % dmg
		player.special_charge += dmg
		queue_free()
	# elif body.is_in_group("WallTileMap"):
		# linear_velocity = Vector2(0, 0)
		# angular_velocity = 0
		# d_timer /= 2
