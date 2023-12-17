extends Area2D
var dmg = 1
var d_timer = 18
var coll_array = []

func _process(_delta):
	if d_timer == 0:
		queue_free()
	d_timer -= 1

func _on_body_entered(body):
	if body.is_in_group("Enemies") and coll_array.find(body.get_rid()) == -1:
		body.dmg_effect += dmg
		coll_array.append(body.get_rid())
