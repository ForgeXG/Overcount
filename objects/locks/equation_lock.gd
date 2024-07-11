extends CharacterBody2D

@export var final : bool = false
@export var finalmusic : String = "res://audio/music/special/overcounted.mp3"
@export var mode : String = "add"
@export var a : int = 1
@export var b : int = 1
@export var a_range : int = 10
@export var b_range : int = 10
@export var modifiers : Array[String] = [""]

@export var equation : bool = false
@export var ch_min : int = 1
@export var ch_max : int = 5

@export var timer : int = 600
@export var hp_restore : float = 10
var max_timer : int
var timer_active : bool = false
var answer : float = 0
var input = 0

var active = false
var player
var player_dist : float = 1000

var d_timer = -1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if equation:
		timer *= 2 # Accounted for equations being solved slower
		hp_restore *= 2
	max_timer = timer
	
	var ch : int = randi_range(ch_min, ch_max)
	
	modulate.a = 0.8
	input_pickable = true
	
	randomize()
	player = get_tree().get_first_node_in_group("Player")
	
	$UI/CaptionRect/Caption.text = ["Prove you are human.", "Are you a robot?", "Solve this captcha."].pick_random()
	if equation:
		$UI/CaptionRect/Caption.text = ["Find the unknown.", "What is X?", "Solve this equation."].pick_random()
		$UI/AnswerRect/Answer.placeholder_text = "x = ?"
	$UI/CaptionRect/Caption.text += " W to deselect."
	a = randi_range(a, a + a_range)
	b = randi_range(b, b + b_range)
	if mode == "add":
		answer = a + b
		$UI/ProblemRect/Problem.text = str(a) + " + " + str(b)
		if equation:
			$UI/ProblemRect/Problem.text = [str(ch) + "x" + " - " + str(ch * b) + " = " + str(ch * a),
			str(ch) + "x" + " - " + str(ch * a) + " = " + str(ch * b),
			str(ch * a) + " + " + str(ch * b) + " = " + str(ch) + "x"].pick_random()
	elif mode == "sub":
		answer = a - b
		$UI/ProblemRect/Problem.text = str(a) + " - " + str(b)
		if equation:
			$UI/ProblemRect/Problem.text = [str(ch * a) + " - " + str(ch) + "x" + " = " + str(ch * b),
			str(ch) + "x" + " + " + str(ch * b) + " = " + str(ch * a),
			str(ch * a) + " - " + str(ch * b) + " = " + str(ch) + "x"].pick_random()
	elif mode == "mul":
		answer = a * b
		$UI/ProblemRect/Problem.text = str(a) + " × " + str(b)
		if equation:
			$UI/ProblemRect/Problem.text = [str(ch) + "x" + " / " + str(ch * b) + " = " + str(a),
			str(ch) + "x" + " / " + str(ch * a) + " = " + str(b),
			str(ch * a) + " × " + str(ch * b) + " = " + str(ch * ch) + "x"].pick_random()
	elif mode == "div":
		answer = float(a) / float(b)
		$UI/ProblemRect/Problem.text = str(a) + " / " + str(b)
		if equation:
			$UI/ProblemRect/Problem.text = [str(ch) + "x" + " × " + str(ch * b) + " = " + str(a),
			str(ch * a) + " / " + "x" + " = " + str(ch * b),
			str(ch * a) + " / " + str(ch * b) + " = " + str(ch) + "x"].pick_random()
	elif mode == "divi":
		answer = floori(a / b)
		$UI/ProblemRect/Problem.text = str(a) + " // " + str(b)
	elif mode == "power":
		answer = a ** b
		$UI/ProblemRect/Problem.text = str(a) + superscript_numbers(str(b))
	elif mode == "root":
		answer = a ** (1 / float(b))
		$UI/ProblemRect/Problem.text = superscript_numbers(str(b)) + "√" + str(a)
		if equation:
			$UI/ProblemRect/Problem.text = ["x" + superscript_numbers(str(b)) + " = " + str(a),
			"x" + superscript_numbers(str(b)) + " + " + str(ch) + "x" + " = " + str(a + ch * answer)].pick_random() + ", x > 0"
	elif mode == "log":
		answer = log(b) / log(a) # a = base, b = value
		$UI/ProblemRect/Problem.text = "log" + subscript_numbers(str(a)) + str(b)
		# if equation:
			# $UI/ProblemRect/Problem.text = ["x" + superscript_numbers(str(b)) + " = " + str(a),
			# "x" + superscript_numbers(str(b)) + " + " + str(ch) + "x" + " = " + str(a + ch * answer)].pick_random() + ", x > 0"
	
	# Modifiers
	if "-" in modifiers:
		answer = -answer
		$UI/ProblemRect/Problem.text = "-(" + $UI/ProblemRect/Problem.text + ")"

func _process(_delta):
	player_dist = position.distance_to(player.position)
	
	if timer_active and timer > 0:
		timer -= 1
		$UI/TimebarRect.size.y = 88 * float(timer) / max_timer
	
	if d_timer == -1:
		$UI.visible = active
		if active:
			input = $UI/AnswerRect/Answer.text
			if is_equal_approx(answer, float(input)) and input != "":
				player.heal_effect += float(timer) / max_timer * hp_restore
				d_timer = 60
				$UI.visible = false
				modulate.a = 0.5
				$Coll.set_deferred("disabled", true)
				velocity.x = randi_range(100, 300)
				velocity.y = randi_range(-500, -100)
			elif a == 9 and b == 10 and is_equal_approx(answer, 19) and input == "21":
				get_tree().change_scene_to_file("res://levels/level_stupid.tscn")

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
			get_parent().get_node("Player/PlayerUI/EscapeAnim").play("activate")
			
			get_tree().call_group("OnOff", "switch", 0)
			
			get_parent().get_node("Player/Camera").zoom = Vector2(4.1, 4.1)
			get_parent().get_node("Player/Camera").wiggle = get_parent().get_node("Player/Camera").wiggle * 2 + 0.0002
			
			get_parent().get_node("MusicPlayer").set_stream(load(finalmusic))
			get_parent().get_node("MusicPlayer").volume_db = 2
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
		timer_active = true
		modulate.a = 1


func _on_mouse_exited():
	pass
	
	
func superscript_numbers(s: String):
	var result : String = ""
	var normal_nums : Array[String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
	var superscript_nums : Array[String] = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]
	
	for el in s:
		var n_ind : int = normal_nums.find(el)
		if n_ind != -1:
			result += superscript_nums[n_ind]
		else:
			result += el
	
	return result

func subscript_numbers(s: String):
	var result : String = ""
	var normal_nums : Array[String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
	var superscript_nums : Array[String] = ["₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉"]
	for el in s:
		var n_ind : int = normal_nums.find(el)
		if n_ind != -1:
			result += superscript_nums[n_ind]
		else:
			result += el
	
	return result
