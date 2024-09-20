extends StaticBody2D

@export var blocked : Array[String] = ["Player"]
var coll_list : Array[Node2D] = []
var start_position : Vector2 = Vector2.ZERO

func _ready() -> void:
	start_position = position
	# Collision Layers 9-12 are reserved for the filter interactions
	if "Player" in blocked:
		$PlayerIcon.show()
		collision_layer += 2 ** 8
		# collision_mask += 2 ** 8
	if "Laser" in blocked:
		$LaserIcon.show()
		$AreaDetector.collision_mask += 2 ** 9
	if "Bullet" in blocked:
		$BulletIcon.show()
		$AreaDetector.collision_mask += 2 ** 10
	if "Enemies" in blocked:
		$EnemyIcon.show()
		collision_layer += 2 ** 11
		# collision_mask += 2 ** 11


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	# for body in coll_list:
		# if body.is_in_group("Player"):
			# body.s_frames = 10
			# body.mach = 0
			# body.velocity = -(position - body.position).normalized() * 120
	# move_and_slide()
	for area : Area2D in $AreaDetector.get_overlapping_areas():
		for i in blocked:
			if area.is_in_group(i):
				if i == "Laser":
					# print("LASER COLLIDED")
					area.extension_speed = Vector2.ZERO
	for body : Node2D in $AreaDetector.get_overlapping_bodies():
		for i in blocked:
			if body.is_in_group(i):
				if i == "Bullet":
					# print("BULLET COLLIDED")
					body.linear_velocity = Vector2.ZERO
					body.gravity_scale = 0
					body.derivatives[0] = 0
					body.derivatives[1] = 0
				elif i == "Player":
					pass
					# print("PLAYER COLLIDED")
					# coll_list.append(body)
				else:
					body.velocity = Vector2.ZERO
				break
	# for body in get_slide_collision_count():
		# var collision = get_slide_collision(body)
		# var coll = collision.get_collider()
		# for i in blocked:
			# if coll.is_in_group(i):
				# if i == "Bullet":
					# print("BULLET COLLIDED")
					# coll.linear_velocity = Vector2.ZERO
					# coll.gravity_scale = 0
					# coll.derivatives[0] = 0
					# coll.derivatives[1] = 0
				# elif i == "Player":
					# print("PLAYER COLLIDED")
					# coll_list.append(body)
				# else:
					# coll.velocity = Vector2.ZERO
				# break
	pass
	# var coll = move_and_collide(constant_linear_velocity)
	# if coll:
		# for i in blocked:
			# if coll.get_collider().is_in_group(i):
				# if i != "Bullet":
					# coll.get_collider().velocity = Vector2.ZERO
				# else:
					# coll.get_collider().linear_velocity = Vector2.ZERO


func _on_body_entered(body: Node2D) -> void:
	for i in blocked:
		if body.is_in_group(i):
			if i == "Bullet":
				print("BULLET COLLIDED")
				body.linear_velocity = Vector2.ZERO
				body.gravity_scale = 0
				body.derivatives[0] = 0
				body.derivatives[1] = 0
			elif i == "Laser":
				print("LASER COLLIDED")
				body.extension_speed = Vector2.ZERO
			elif i == "Player":
				print("PLAYER COLLIDED")
				coll_list.append(body)
			else:
				body.velocity = Vector2.ZERO
			break


func _on_body_exited(body: Node2D) -> void:
	if body in coll_list:
		coll_list.erase(body)
