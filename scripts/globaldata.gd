extends Node2D

# Save data
var enable_cheats : bool = true
var autorun : bool = true
var coins : int = 0
static var PHI : float = 1.61803399

# This is the script for global data that any scene can refer to.

func spawn_enemy(spawner : Node2D, enemy : PackedScene, offset : Vector2 = Vector2.ZERO, hp_m : float = 1):
	var spawned = enemy.instantiate()
	spawner.add_sibling(spawned)
	spawned.global_position = self.global_position + offset
	spawned.hp *= hp_m
	spawned.maxhp *= hp_m
	pass
