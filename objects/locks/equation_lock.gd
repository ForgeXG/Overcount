extends CharacterBody2D

@export var final : bool = false
@export var finalmusic : String = "res://audio/music/OH.mp3"
@export var mode : String = "add"
@export var a : int = 1
@export var b : int = 1
@export var a_range : int = 10
@export var b_range : int = 10
var answer : int = 0
var input = 0

var active = false
var player
var player_dist : float = 1000

var d_timer = -1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	modulate.a = 0.8
	input_pickable = true
	
	randomize()
	player = get_parent().get_node("Player")
	
	$UI/CaptionRect/Caption.text = ["Prove you are human.", "Are you a robot?", "Solve this captcha."].pick_random()
	$UI/CaptionRect/Caption.text += " W to deselect."
	a = randi_range(a, a + a_range)
	b = randi_range(b, b + b_range)
	if mode == "add":
		answer = a + b
		$UI/ProblemRect/Problem.text = str(a) + " + " + str(b)
	elif mode == "sub":
		answer = a - b
		$UI/ProblemRect/Problem.text = str(a) + " - " + str(b)
	elif mode == "mul":
		answer = a * b
		$UI/ProblemRect/Problem.text = str(a) + " x " + str(b)
	elif mode == "div":
		answer = a / b
		$UI/ProblemRect/Problem.text = str(a) + " / " + str(b)
	elif mode == "divi":
		answer = floori(a / b)
		$UI/ProblemRect/Problem.text = str(a) + " // " + str(b)
	elif mode == "power":
		answer = a ** b
		$UI/ProblemRect/Problem.text = str(a) + " ^ " + str(b)
	elif mode == "root":
		answer = a ** (1 / float(b))
		$UI/ProblemRect/Problem.text = str(a) + " ^ (1/" + str(b) + ")"

func _process(_delta):
	player_dist = position.distance_to(player.position)
	
	if d_timer == -1:
		$UI.visible = active
		if active:
			input = $UI/AnswerRect/Answer.text
			if int(input) == answer and input != "":
				d_timer = 60
				$UI.visible = false
				modulate.a = 0.5
				$Coll.set_deferred("disabled", true)
				velocity.x = randi_range(100, 300)
				velocity.y = randi_range(-500, -100)

		if Input.is_action_just_pressed("key_w"):
			active = false
			modulate.a = 0.8

	if d_timer > 0:
		d_timer -= 1
	if d_timer == 0:
		if final:
			get_parent().get_node("Player").escape_time_active = true
			get_parent().get_node("Player/PlayerUI/OvercountSign").visible = true
			get_parent().get_node("Player/PlayerUI/OvercountSign").texture.pause = false
			get_parent().get_node("Player/PlayerUI/OvercountSign").texture.current_frame = 0
			
			get_tree().call_group("EscapeWall", "switch")
			
			get_parent().get_node("Player/Camera").zoom = Vector2(4.1, 4.1)
			get_parent().get_node("Player/Camera").wiggle = get_parent().get_node("Player/Camera").wiggle * 2 + 0.0002
			
			get_parent().get_node("MusicPlayer").set_stream(load(finalmusic))
			# get_parent().get_node("MusicPlayer").volume_db = -4
			get_parent().get_node("MusicPlayer").play()
			
			get_parent().get_node("LevelPortal").active = true
		queue_free()
		
func _physics_process(delta):
	if d_timer > 0:
		scale.x += 0.05
		scale.y += 0.05
		velocity.y += gravity * delta
		
	move_and_slide()

func _on_mouse_entered():
	if player_dist <= 64:
		active = true
		modulate.a = 1


func _on_mouse_exited():
	pass
