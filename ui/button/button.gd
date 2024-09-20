extends Button

# Teleport data
@export var button_type : int = 0 # 0 is teleport, 1 is with ui
var button_activated : bool = false
@export var destination : String = "res://levels/start/titlescreen.tscn"
@export var coins_fee : int = 0 # For type-0 buttons
# Advanced level data (for type-1 buttons)
@export var level_title : String = ""
@export_multiline var level_desc : String = ""

func _ready():
	$ButtonUI.visible = false
	if button_type == 1:
		$ButtonUI/Control/LevelTitle.text = level_title
		$ButtonUI/Control/LevelDesc.text = level_desc
		$ButtonUI/Control/Difficulty.texture = icon
		$ButtonUI/Control/TeleporterButton.text = "Enter for " + str(coins_fee) + " ⍟"


func _process(_delta):
	pivot_offset = size / 2
	if button_activated:
		if coins_fee <= 0:
			get_tree().change_scene_to_file(destination)
		G.coins -= ceil(coins_fee / 2)
		coins_fee -= ceil(coins_fee / 2)
		if coins_fee == 1:
			coins_fee -= 1
			G.coins -= 1
		$ButtonUI/Control/TeleporterButton.text = "Enter for " + str(coins_fee) + " ⍟"


func _button_down():
	if button_type == 0:
		get_tree().change_scene_to_file(destination)
	elif button_type == 1:
		$ButtonUI.visible = true


func _mouse_entered():
	scale = Vector2(1.25, 1.25)


func _mouse_exited():
	scale = Vector2(1, 1)


func _child_button_down():
	if G.coins >= coins_fee and coins_fee >= 0:
		button_activated = true

func _child_button_pressed():
	pass


func _cancel_button_down():
	scale = Vector2(1, 1)
	if button_type == 1:
		$ButtonUI.visible = false
