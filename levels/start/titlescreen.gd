extends Control

@export var fadein : float = 100
@export var fadeout : float = 20
var appear : bool = true

func _ready():
	$Disclaimer.modulate.a = 0
	$Disclaimer.visible = true
	$LevelSelection.modulate.a = 0
	if G.coins > 0:
		$LevelSelection/Level1/Pointer.hide()
		$LevelSelection/Level1/Pointer2.hide()

func _process(_delta):
	# Global Data
	$LevelSelection/GlobalData/TextCoins.text = str(G.coins)
	if G.enable_cheats:
		if Input.is_action_just_pressed("key_cheat_give_coins"): # P
			G.coins += 1000
	if appear:
		$Disclaimer.modulate.a += 1 / fadein
		if $Disclaimer.modulate.a >= 1:
			appear = false
	else:
		$Disclaimer.modulate.a -= 1 / fadeout
		$LevelSelection.modulate.a += 2 / fadeout
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		$Disclaimer.modulate.a = 0
		$LevelSelection.modulate.a = 1
		appear = false
