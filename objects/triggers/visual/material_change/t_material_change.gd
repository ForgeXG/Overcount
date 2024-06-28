extends Area2D

@export var timer : float = -1
@export var open : bool = true
@export var s_group : int = 0
@export var s_group_target : int = 0
@export var target_shader : Shader

func _process(delta):
	if timer > 0:
		timer -= 60 * delta
	elif timer > -1:
		activate()

func _on_body_entered(body):
	if body.is_in_group("Player") and open and timer < -0.5:
		activate()

func activate():
	get_tree().call_group("T", "t_switch_material", s_group_target, target_shader)
	open = false
	modulate.a = 0
