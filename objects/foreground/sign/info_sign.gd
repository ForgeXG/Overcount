extends Area2D

@export_multiline var txt : String = ""
var active = false
var v_ratio = 0

func _ready():
	$UI.visible = false

func _process(_delta):
	$UI.visible = v_ratio > 0
	
	if active:
		v_ratio = clamp(v_ratio + 0.02, 0, 1)
	else:
		v_ratio = clamp(v_ratio - 0.1, 0, 1)
	
	$UI/InfoRect/InfoText.text = txt
	if v_ratio < 1:
		$UI/InfoRect/InfoText.text = txt + "█"
	$UI/InfoRect/InfoText.visible_ratio = v_ratio

func _on_mouse_shape_entered(_shape_idx : int):
	active = true

func _on_mouse_shape_exited(_shape_idx : int):
	active = false
