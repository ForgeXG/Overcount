extends RichTextLabel
@export var mode : String = "default"
@export var val : float = 0
@export var maxval : float = 100
var initial_size : Vector2 = Vector2(0, 0)
var scale_power = 1

func _ready():
	# To-do: Modes adjusting to desired parameter at the start like health or cooldown
	var player = get_parent().get_parent()
	if mode == "health":
		maxval = player.maxhp
	elif mode == "cooldown":
		maxval = player.weapon.cooldown
	elif mode == "energy":
		maxval = player.maxenergy
	elif mode == "score":
		maxval = player.maxscore
		scale_power = 1
	
	initial_size = $FullRect.size - Vector2(8, 0)

func _process(_delta):
	val = float(text)
	if maxval != 0 and val != 0:
		$FillerRect.size.x = initial_size.x * pow(val / maxval, scale_power)
	if int(text) == 0:
		$FillerRect.size.x = 0
		
func reassign():
	var player = get_parent().get_parent()
	if mode == "health":
		maxval = player.maxhp
	elif mode == "cooldown":
		maxval = player.weapon.cooldown
	elif mode == "energy":
		maxval = player.maxenergy
	elif mode == "score":
		maxval = player.maxscore
		scale_power = 1
