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
var player

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	start_pos = global_position
	zoom *= ProjectSettings.get_setting("display/window/size/viewport_width") / 1920.0

func _physics_process(_delta):
	if static_x:
		global_position.x = start_pos.x
	if static_y:
		global_position.y = start_pos.y
	rotation += sin(wiggle_sine) * wiggle
	wiggle_sine += PI / 180

func _process(delta):
	# Zooming (for non-timeline cameras)
	if timeline.size() == 0 and !("Solving" in player.status_effects):
		if Input.is_action_just_released("key_zoom_in") and zoom.x < 9:
			zoom.x += 0.25 * delta * 60
			zoom.y += 0.25 * delta * 60
		if Input.is_action_just_released("key_zoom_out") and zoom.x > 1:
			zoom.x -= 0.25 * delta * 60
			zoom.y -= 0.25 * delta * 60
	# Timeline camera
	if timeline.size() > 0:
		if m_timer >= timeline[timeline_index].w:
			vel.x = timeline[timeline_index].x
			vel.y = timeline[timeline_index].y
			zoom_spd = timeline[timeline_index].z
			if timeline_index < timeline.size() - 1:
				timeline_index += 1
		position += vel * delta * 60
		zoom.x += zoom_spd * delta * 60
		zoom.y += zoom_spd * delta * 60
		m_timer += delta
		queue_redraw()

func apply_stats():
	timeline_index = 0
	while m_timer > timeline[timeline_index + 1].w:
		timeline_index += 1
	if m_timer < timeline[0].w:
		vel = Vector2.ZERO
		zoom_spd = 0
	else:
		vel.x = timeline[timeline_index].x
		vel.y = timeline[timeline_index].y
		zoom_spd = timeline[timeline_index].z
	position_smoothing_speed = 5

func _on_draw():
	draw_line(Vector2.ZERO, vel * 16, Color.from_hsv(1 - vel.length() / 4, 1, 1), 2, false)
