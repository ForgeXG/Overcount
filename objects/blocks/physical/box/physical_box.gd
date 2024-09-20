extends RigidBody2D

@export var y_death : float = 8
@export var pivoted : bool = false
@export var rot_spd : float = 0 # Radians/Frame
@export var parent_pivot : RigidBody2D

func _ready() -> void:
	if pivoted:
		freeze = true
		# modulate = modulate.inverted()
	if scale != Vector2.ONE:
		var shape = RectangleShape2D.new()
		shape.size = Vector2(16 * scale.x, 16 * scale.y)
		$Coll.set_shape(shape)
		$Sprite.size = global_scale * 16
		$Sprite.position -= (scale - Vector2.ONE) * 8
		# if get_parent().is_in_group("Physical"):
			# $Sprite.position += get_parent().position
		scale = Vector2.ONE


func _physics_process(delta: float) -> void:
	rotation += rot_spd * delta * 60
	if pivoted:
		material.set_shader_parameter("tint", (int(abs(rotation_degrees) + 45) % 90 - 45) / 90.0 * 2)
	# if parent_pivot != null:
		# position
	if position.y >= y_death:
		queue_free()


func _on_draw() -> void:
	# draw_set_transform(Vector2.ZERO, -rotation, Vector2(1.0 / scale.x, 1.0 / scale.y))
	draw_line(Vector2.ZERO, linear_velocity, Color.WHITE, 2, false)
