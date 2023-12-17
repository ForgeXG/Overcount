extends Area2D

@export var txt : String = ""
var active = false

func _ready():
	$UI.visible = false

func _process(_delta):
	$UI/InfoRect/InfoText.text = txt

func _on_mouse_shape_entered(_shape_idx):
	$UI.visible = true

func _on_mouse_shape_exited(_shape_idx):
	$UI.visible = false
