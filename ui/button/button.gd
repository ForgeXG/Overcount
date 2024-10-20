extends Button

# Teleport data
@export var button_type : int = 0 # 0 is teleport, 1 is with ui
var button_activated : bool = false
@export var function : String = "Map"


func _ready():
	pass


func _process(_delta):
	pass


func _button_down():
	match function:
		"Map":
			get_tree().change_scene_to_file("res://levels/start/titlescreen.tscn")
		"Main Menu":
			get_tree().change_scene_to_file("res://levels/start/startscreen.tscn")
		"Exit":
			get_tree().quit()


func _mouse_entered():
	scale = Vector2(1.1, 1.1)
	rotation = randf_range(-PI / 12, PI / 12)


func _mouse_exited():
	scale = Vector2(1, 1)
	rotation = 0
