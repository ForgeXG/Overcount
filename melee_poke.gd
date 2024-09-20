extends Area2D
var dmg : float = 1
var d_timer = 18
var coll_array = []

var player


func _ready():
	player = get_tree().get_first_node_in_group("Player")


func _process(_delta):
	if d_timer == 0:
		queue_free()
	d_timer -= 1


func _on_body_entered(body):
	if body.is_in_group("Enemies") and coll_array.find(body.get_rid()) == -1:
		player.dps_next += dmg
		body.dmg_effect += dmg
		coll_array.append(body.get_rid())
		var dmg_number = preload("res://ui/damage_number.tscn").instantiate()
		get_tree().current_scene.add_child(dmg_number)
		dmg_number.position = body.position + Vector2(randi_range(8, 24), 0).rotated(randf_range(0, TAU))
		dmg_number.text = "%.1f" % dmg
		player.special_charge += dmg
