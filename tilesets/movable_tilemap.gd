extends TileMap

@export var move_spd : Vector2 = Vector2.ZERO
@export var rot_spd : float = 0
func _process(_delta):
	pass

func _physics_process(delta):
	position += move_spd * delta * 60
	rotation += rot_spd * delta * 60
