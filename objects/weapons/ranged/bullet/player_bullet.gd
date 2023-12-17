extends RigidBody2D
@export var dmg : int = 1
@export var maxd_timer : float = -1
var d_timer : float = -1

func _ready():
	d_timer = maxd_timer

func _process(_delta):
	if d_timer > 0:
		d_timer -= 1
		if d_timer <= 0:
			queue_free()
	modulate.a = d_timer / maxd_timer
	
func _physics_process(_delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("Enemies"):
		position.y -= 16
		body.dmg_effect += dmg
		queue_free()
	# elif body.is_in_group("WallTileMap"):
		# linear_velocity = Vector2(0, 0)
		# angular_velocity = 0
		# d_timer /= 2
