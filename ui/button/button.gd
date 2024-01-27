extends Button

@export var destination : String = "res://levels/start/titlescreen.tscn"

func _process(_delta):
	pivot_offset = size / 2


func _button_down():
	get_tree().change_scene_to_file(destination)


func _mouse_entered():
	scale *= 1.25


func _mouse_exited():
	scale *= 0.8
