extends Node2D

func _ready():
	var a : int = 5
	var b : int = 2
	a = randi_range(a, a)
	b = randi_range(b, b)
	var answer = float(a) / float(b)
	# print(answer)
