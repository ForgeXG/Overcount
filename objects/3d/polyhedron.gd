extends AnimatableBody2D

class_name Polyhedron
@export var vertices : Array[Vector3] = [
Vector3(-8, -8, -8), Vector3(8, -8, -8), Vector3(-8, 8, -8), Vector3(-8, -8, 8),
Vector3(8, 8, -8), Vector3(-8, 8, 8), Vector3(8, -8, 8), Vector3(8, 8, 8)]
var vert : Array[Vector3]
@export var edges : Array[Vector2i] = [
Vector2(0, 1), Vector2(0, 2), Vector2(0, 3), 
Vector2(1, 4), Vector2(1, 6), Vector2(2, 4), 
Vector2(2, 5), Vector2(3, 5), Vector2(3, 6),
Vector2(4, 7), Vector2(5, 7), Vector2(6, 7)]
@export var offset_lerp : float = 0
@export var lerp_speed : float = 0.01
@export var offset_start : Vector3 = Vector3.ZERO # x, y, z
@export var offset_end : Vector3 = Vector3.ZERO # x, y, z
@export var angular_offset : Vector3 = Vector3.ZERO # yz, zx, xy
@export var angular_velocity : Vector3 = Vector3.ZERO # yz, zx, xy
@export var uniform_scale : Vector3 = Vector3.ONE
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
	visible = global_position.distance_to(player.global_position) < 64 * uniform_scale.length()
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
		if angular_velocity != Vector3.ZERO:
			for i in range(0, vert.size()):
				var tr : Transform3D = Transform3D(Basis.IDENTITY, vert[i])
				tr = tr.rotated(Vector3(0, 1, 0), angular_offset.y).orthonormalized()
				tr = tr.rotated(Vector3(0, 0, 1), angular_offset.z).orthonormalized()
				tr = tr.rotated(Vector3(1, 0, 0), angular_offset.x).orthonormalized()
			
				vert[i] = tr.origin
			angular_offset += angular_velocity
		unordered_vert = cross_section()
		unordered_vert.sort_custom(sort_clockwise)
		if len(unordered_vert) >= 3:
			$Coll.polygon = unordered_vert
			$Polygon.polygon = unordered_vert
		else:
			$Coll.polygon = []
			$Polygon.polygon = []


func sort_clockwise(a : Vector2, b : Vector2):
	return a.angle() < b.angle()


func cross_section(): # Intersection with z = 0 plane
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
		var flat_vertex : Vector2 = Vector2.ZERO
		if sign(z1 * z2) <= 0:
			flat_vertex.x = -z1 * (x2 - x1) + x1 * (z2 - z1)
			flat_vertex.y = -z1 * (y2 - y1) + y1 * (z2 - z1)
			flat_vertex /= (z2 - z1)
			coll_vert.append(flat_vertex)
			# print(str(flat_vertex) + "ADDED") 
	# print(coll_vert)
	return coll_vert


func _on_draw() -> void:
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
