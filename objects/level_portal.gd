extends Area2D

@export var destination : String = "" # Destination scene path
@export var active : bool = false
var player


func _ready():
	player = get_parent().get_node("Player")


func _process(_delta):
	if active:
		modulate.a = 1
		modulate.g = 1
		modulate.b = 1
	else:
		modulate.a = 0.1
		modulate.g = 0.2
		modulate.b = 0.2


func _on_body_entered(body):
	if body.is_in_group("Player") and active:
		player.i_frames = 1000000
		player.walk_spd = 0
		player.jump_force = 0
		player.get_node("PlayerUI/WinScreen/ButtonNextLevel").destination = destination
		player.get_node("PlayerUI/WinScreen/WinAnim").play("win")
