extends Area2D
@export var link : Area2D = self
var cooldown = 0

func _ready():
	if link == self:
		modulate = Color(0.5, 0.5, 0.5, 0.5)

func _process(_delta):
	if cooldown > 0:
		cooldown -= 1
	scale.x = 1.2+sin(Time.get_ticks_msec()/100)*0.1
	scale.y = 1.2+sin(Time.get_ticks_msec()/100)*0.1

func _on_body_entered(body):
	if cooldown == 0 and link != self and !body.is_in_group("WallTileMap"):
		body.position = link.position
		cooldown = 60
		link.cooldown = 60
