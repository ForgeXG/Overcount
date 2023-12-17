extends AnimatableBody2D

@export var on : bool = false

func _ready():
	modulate = get_parent().get_node("SquareTileMap").modulate

func _process(_delta):
	if on:
		$Animations.animation = "on"
		$Coll.set_deferred("disabled", false)
		modulate.a = 1
	else:
		$Animations.animation = "off"
		$Coll.set_deferred("disabled", true)
		modulate.a = 0.2

func switch():
	on = !on
