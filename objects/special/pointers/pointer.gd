extends Sprite2D

@export var wiggle_control : bool = false
@export var wiggle_min : float = -0.1
@export var wiggle_max : float = 0.1
@export var wiggle_val : float = 0
@export var wiggle_speed : float = 0.01 # Speed
var start_rot : float = 0

func _ready() -> void:
	$ChildPointer.texture = texture
	$ChildPointer.show()
	self_modulate = Color(0, 0, 0, 0)
	$ChildPointer/Anim.play("wiggle")

func _process(delta: float) -> void:
	if wiggle_control:
		rotation = start_rot + wiggle_val
		wiggle_val += wiggle_speed * delta * 60
		if wiggle_val > wiggle_max:
			wiggle_speed *= -1
			wiggle_val = wiggle_max
		elif wiggle_val < wiggle_min:
			wiggle_speed *= -1
			wiggle_val = wiggle_min
