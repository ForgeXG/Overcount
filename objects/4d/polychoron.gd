extends AnimatableBody2D

class_name Polychoron
@export var vertices : Array[Vector4] = [
Vector4(-1, -1, -1, -1), Vector4(-1, -1, -1, 1), Vector4(-1, -1, 1, -1), Vector4(-1, -1, 1, 1),
Vector4(-1, 1, -1, -1), Vector4(-1, 1, -1, 1), Vector4(-1, 1, 1, -1), Vector4(-1, 1, 1, 1),
Vector4(1, -1, -1, -1), Vector4(1, -1, -1, 1), Vector4(1, -1, 1, -1), Vector4(1, -1, 1, 1),
Vector4(1, 1, -1, -1), Vector4(1, 1, -1, 1), Vector4(1, 1, 1, -1), Vector4(1, 1, 1, 1)] # Tesseract
var vert : Array[Vector4]
@export var edges : Array[Vector2i] = [
Vector2i(0, 1), Vector2i(0, 2), Vector2i(0, 4), Vector2i(0, 8),
Vector2i(1, 3), Vector2i(1, 5), Vector2i(1, 9), 
Vector2i(2, 3), Vector2i(2, 6), Vector2i(2, 10), 
Vector2i(3, 7), Vector2i(3, 11), 
Vector2i(4, 5), Vector2i(4, 6), Vector2i(4, 12), 
Vector2i(5, 7), Vector2i(5, 13), Vector2i(6, 7), Vector2i(6, 14), 
Vector2i(7, 15), 
Vector2i(8, 9), Vector2i(8, 10), Vector2i(8, 12), 
Vector2i(9, 11), Vector2i(9, 13), Vector2i(10, 11), Vector2i(10, 14), 
Vector2i(11, 15), 
Vector2i(12, 13), Vector2i(12, 14), Vector2i(13, 15), Vector2i(14, 15)]
@export var faces : Array = []
@export var offset_lerp : float = 0
@export var lerp_speed : float = 0.01
@export var offset_start : Vector4 = Vector4.ZERO # x, y, z, w
@export var offset_end : Vector4 = Vector4.ZERO # x, y, z, w

# var angular_offset : Transform4D = Transform4D.new()
var avvx : Vector4 = Vector4(1, 0, 0, 0)
var avvy : Vector4 = Vector4(0, 1, 0, 0)
var avvz : Vector4 = Vector4(0, 0, 1, 0)
var avvw : Vector4 = Vector4(0, 0, 0, 1)
var avvo : Vector4 = Vector4(0, 0, 0, 0)

# var angular_velocity : Transform4D = Transform4D.from_vectors(avvx, avvy, avvz, avvw, avvo)
@export var rotation_v1 : Vector4 = Vector4(1, 0, 0, 0)
@export var rotation_v2 : Vector4 = Vector4(0, 1, 0, 0)
@export var rotation_v3 : Vector4 = Vector4(0, 0, 1, 0)
@export var rotation_v4 : Vector4 = Vector4(0, 0, 0, 1)
@export var theta1 : float = 0
@export var theta1_vel : float = 0
@export var theta2 : float = 0
@export var theta2_vel : float = 0

@export var uniform_scale : Vector4 = Vector4.ONE
var template : String = "Any"
var temp_a : float = 0
var temp_b : float = 0
var temp_c : float = 0
var temp_d : float = 0
@export var stationary : bool = false
@export var hazard : bool = false

var unordered_vert : Array[Vector2] = []

var player : Player

func _ready() -> void:
	if hazard:
		modulate = Color.RED
	for i in range(0, vertices.size()):
		vertices[i] *= uniform_scale
	vert = vertices.duplicate(true)
	player = get_tree().get_first_node_in_group("Player")


func _process(delta: float):
	visible = global_position.distance_to(player.global_position) < 256 * uniform_scale.length()
	if visible:
		queue_redraw()


func _physics_process(delta: float):
	# Movement
	
	if !stationary:
		if lerp_speed != 0:
			for i in range(0, vert.size()):
				vert[i] = vertices[i] + lerp(offset_start, offset_end, offset_lerp)
				offset_lerp += lerp_speed * delta * 60
		if offset_lerp > 1 or offset_lerp < 0:
			lerp_speed = -lerp_speed
		# Rotation
		for i in range(0, vert.size()):
			# var tr : Transform4D = Transform4D.new()
			# tr = tr.compose(angular_velocity)
			vert[i] = rotate_vector_plane(vert[i], rotation_v1, rotation_v2, theta1 / 100)
			vert[i] = rotate_vector_plane(vert[i], rotation_v3, rotation_v4, theta2 / 100)
			theta1 += theta1_vel
			theta2 += theta2_vel
		# angular_offset = angular_offset.compose(angular_velocity)
		unordered_vert = cross_section()
		unordered_vert.sort_custom(sort_clockwise)
		$Coll.polygon = unordered_vert
		$Polygon.polygon = unordered_vert


func sort_clockwise(a : Vector2, b : Vector2):
	return a.angle() < b.angle()


func cross_section(): # Intersection with z = 0, w = 0 plane
	var coll_vert : Array[Vector2] = []
	for i : Vector2i in edges:
		var v1 = vert[i.x]
		var v2 = vert[i.y]
		var x1 = v1.x
		var x2 = v2.x
		var y1 = v1.y
		var y2 = v2.y
		var z1 = v1.z
		var z2 = v2.z
		var w1 = v1.w
		var w2 = v2.w
		var flat_vertex : Vector2 = Vector2.ZERO
		if sign(z2 * z1) <= 0 and (false or sign(w2 * w1) <= 0):
			flat_vertex.x = -z1 * (x2 - x1) + x1 * (z2 - z1)
			flat_vertex.y = -z1 * (y2 - y1) + y1 * (z2 - z1)
			flat_vertex /= (z2 - z1)
			coll_vert.append(flat_vertex)
			# print(str(flat_vertex) + "ADDED") 
	# print(coll_vert)
	return coll_vert


static func rotate_vector_plane(a: Vector4, u: Vector4, v: Vector4, theta: float) -> Vector4:
	# Ensure u and v are orthonormal
	if theta == 0:
		return a
	
	u = u.normalized()
	v = (v - v.dot(u) * u).normalized() # Gram-Schmidt process
	
	# Rotation matrix in the u-v plane
	var cos_theta = cos(theta)
	var sin_theta = sin(theta)
	
	# Rotation matrix elements
	var r_uu = u * cos_theta + v * sin_theta
	var r_uv = u * -sin_theta + v * cos_theta
	
	# Project a onto the u and v vectors
	var proj_u = a.dot(u)
	var proj_v = a.dot(v)
	
	# Rotate the projections
	var rotated_proj = r_uu * proj_u + r_uv * proj_v
	
	# Project the rotated vector back to 4D space
	var result = rotated_proj + (a - (proj_u * u + proj_v * v))
	return result


func _on_draw() -> void:
	# print("DRAWING 4D PROJECTION")
	for i in edges:
		var draw_color : Color = Color.BLACK
		draw_color.a = abs(vert[i.x].z + vert[i.y].z) / 64
		if vert[i.x].z > 0 and vert[i.y].z > 0:
			draw_color = Color.ORANGE
		elif vert[i.x].z < 0 and vert[i.y].z < 0:
			draw_color = Color.CYAN
		else:
			draw_color.a = 0.7
		draw_line(Vector2(vert[i.x].x, vert[i.x].y), Vector2(vert[i.y].x, vert[i.y].y),
		 draw_color, 1, false)
	for i in vert:
		var draw_color : Color = Color.BLACK
		if i.z > 0:
			draw_color = Color.ORANGE
		elif i.z < 0:
			draw_color = Color.CYAN
		draw_color.a = 32 - abs(i.z) / 32
		draw_circle(Vector2(i.x, i.y), 1, draw_color, true)
	for i in range(0, unordered_vert.size() - 1):
		draw_line(unordered_vert[i], unordered_vert[i + 1], Color.BLACK, 1, false)
	if unordered_vert.size() > 0:
		draw_line(unordered_vert[-1], unordered_vert[0], Color.BLACK, 1, false)
