extends Area2D

@export var destination : String = "" # Destination scene path
@export var active : bool = false

func _process(_delta):
	if active:
		modulate.a = 1
		modulate.g = 1
		modulate.b = 1
	else:
		modulate.a = 0.1
		modulate.g = 0.2
		modulate.b = 0.2

func _on_body_entered(body):
	if body.is_in_group("Player") and active:
		get_tree().change_scene_to_file(destination)
