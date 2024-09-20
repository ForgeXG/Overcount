extends CollisionObject2D

@export var rot_spd : float = 0.1
@export var pivot : Vector2 = Vector2.ZERO
@export var absolute : bool = false
var dist_to_pivot : float = 0
var pivot_rot : float = 0
var start_pos : Vector2 = Vector2.ZERO

func _ready() -> void:
	if absolute:
		pivot_rot = global_position.angle_to_point(pivot)
		dist_to_pivot = global_position.distance_to(pivot)
	else:
		pivot_rot = pivot.angle() + PI / 2
		start_pos = position + pivot
		dist_to_pivot = pivot.length()


func _process(delta):
	rotation += 10
	pivot_rot += rot_spd * delta * 60
	if absolute:
		global_position = pivot + Vector2(dist_to_pivot, 0).rotated(pivot_rot)
	else:
		position = start_pos + pivot.rotated(pivot_rot)


func _on_draw() -> void:
	# draw_set_transform(-position, 0, scale)
	# draw_circle(pivot, pivot.length(), Color.RED, false, 4, false)
	pass
