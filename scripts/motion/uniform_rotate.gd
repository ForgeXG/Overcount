extends CollisionObject2D

@export var rot_spd : float = 0.1

func _process(delta):
	rotation += rot_spd * delta * 60
