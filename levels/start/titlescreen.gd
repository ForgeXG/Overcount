extends Control

@export var fadein : float = 120
@export var fadeout : float = 60
var appear : bool = true

func _ready():
	$Disclaimer.modulate.a = 0
	$Disclaimer.visible = true
	$LevelSelection.modulate.a = 0

func _process(_delta):
	# Global Data
	$LevelSelection/GlobalData/TextCoins.text = str(G.coins)
	if G.enable_cheats:
		if Input.is_action_pressed("key_cheat_give_coins"): # P
			G.coins += 10000
	if appear:
		$Disclaimer.modulate.a += 1 / fadein
		if $Disclaimer.modulate.a >= 1:
			appear = false
	else:
		$Disclaimer.modulate.a -= 1 / fadeout
		$LevelSelection.modulate.a += 2 / fadeout
