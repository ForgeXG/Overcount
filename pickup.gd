extends Area2D

@export var value : int = 1
@export var type : String = "Gem"

func _process(_delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.score += value
		queue_free()
