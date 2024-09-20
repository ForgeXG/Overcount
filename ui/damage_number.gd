extends RichTextLabel

var target : String = "Enemy"
var d_timer : int = 30
var maxd_timer : int = 30

func _process(_delta):
	if d_timer == 0:
		queue_free()
	d_timer -= 1
	modulate.s += 1.0 / d_timer
	modulate.a -= 1.0 / d_timer
	if target == "Player":
		modulate.v = 0.5


func _physics_process(delta):
	position.y -= 12.0 * (maxd_timer - d_timer) * delta
	scale += Vector2(float(text) * 0.05, float(text) * 0.05)
