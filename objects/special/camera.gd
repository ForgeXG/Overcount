extends Camera2D

var start_pos : Vector2 = Vector2(0, 0)
@export var static_x : bool = false
@export var static_y : bool = false
@export var wiggle : float = 0
var wiggle_sine = 0

var m_timer : float = 0
@export var timeline : Array[Vector4] # Velocity(x, y), zoom, time marker
var vel : Vector2 = Vector2(0, 0)
var zoom_spd : float = 0
var timeline_index : int = 0

func _ready():
	start_pos = global_position

func _physics_process(_delta):
	if static_x:
		global_position.x = start_pos.x
	if static_y:
		global_position.y = start_pos.y
	rotation += sin(wiggle_sine) * wiggle
	wiggle_sine += PI / 180

func _process(delta):
	if timeline.size() > 0:
		if m_timer >= timeline[timeline_index].w:
			vel.x = timeline[timeline_index].x
			vel.y = timeline[timeline_index].y
			zoom_spd = timeline[timeline_index].z
			if timeline_index < timeline.size() - 1:
				timeline_index += 1
		position += vel
		zoom.x += zoom_spd
		zoom.y += zoom_spd
		m_timer += delta

func _on_draw():
	pass
