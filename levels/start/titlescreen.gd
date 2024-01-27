extends Control

@export var fadein : float = 240
@export var fadeout : float = 60
var appear : bool = true

func _ready():
	$Disclaimer.modulate.a = 0
	$LevelSelection.modulate.a = 0

func _process(_delta):
	if appear:
		$Disclaimer.modulate.a += 1 / fadein
		if $Disclaimer.modulate.a >= 1:
			appear = false
	else:
		$Disclaimer.modulate.a -= 1 / fadeout
		$LevelSelection.modulate.a += 2 / fadeout
