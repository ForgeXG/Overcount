extends Area2D

@export var value : int = 1
@export var type : String = "Gem"
var player

func _process(_delta):
	player = get_parent().get_node("Player")

func _on_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("PiBall"):
		player.score += value
		queue_free()
