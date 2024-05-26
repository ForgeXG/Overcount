extends Area2D

@export var timeline_camera : bool = false
@export var max_cooldown : int = 60
var cooldown : int = 0
var activated : bool = false
var timer : float = 0

@export var draw_font : SystemFont

func _process(delta):
	if cooldown > 0:
		modulate = Color(0.5, 0.5, 0.5, 0.8)
		cooldown -= 1
	elif !activated:
		modulate = Color.WHITE
	else:
		modulate = Color.YELLOW_GREEN
	rotation = sin(Time.get_ticks_msec() / 200) * 0.01
	timer += delta
	queue_redraw()

func _on_body_entered(body):
	if body.is_in_group("Player") and cooldown == 0 and !activated:
		body.checkpoint_position = position
		body.checkpoint_music_position = get_parent().get_node("MusicPlayer").get_playback_position()	
		if timeline_camera:
			body.checkpoint_camera_position = get_parent().get_node("Camera").position
			body.checkpoint_camera_zoom = get_parent().get_node("Camera").zoom
			body.checkpoint_camera_timeline = get_parent().get_node("Camera").m_timer
		cooldown = max_cooldown
		activated = true

func _draw():
	if activated:
		draw_string(draw_font, Vector2(0, -16), "Saved!", HORIZONTAL_ALIGNMENT_FILL, -1, 12, 
		Color.WHITE)
	for i in range(8):
		draw_arc(Vector2.ZERO, 16, TAU / 8 * i + timer, TAU / 8 * i + TAU / 16 + timer, 2, Color.GREEN_YELLOW, 4, false)
