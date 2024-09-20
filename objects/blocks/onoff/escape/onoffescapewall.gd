extends AnimatableBody2D

@export var on : bool = false
@export var s_group : int = 0

func _ready():
	modulate = get_parent().get_node("SquareTileMap").modulate
	if true:
		if on:
			$Animations.animation = "on"
			$Coll.set_deferred("disabled", false)
			modulate.a = 1
		else:
			$Animations.animation = "off"
			$Coll.set_deferred("disabled", true)
			modulate.a = 0.2

func switch(switch_group):
	if switch_group == s_group:
		on = !on
		if on:
			$Animations.animation = "on"
			$Coll.set_deferred("disabled", false)
			modulate.a = 1
		else:
			$Animations.animation = "off"
			$Coll.set_deferred("disabled", true)
			modulate.a = 0.2
