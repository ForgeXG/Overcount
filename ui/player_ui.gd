extends CanvasLayer

var rank_textures = [preload("res://ui/ui_sprites/ranks/Rank0.png"),
preload("res://ui/ui_sprites/ranks/Rank1.png"),
preload("res://ui/ui_sprites/ranks/Rank2.png"),
preload("res://ui/ui_sprites/ranks/Rank3.png"),
preload("res://ui/ui_sprites/ranks/Rank4.png"),
preload("res://ui/ui_sprites/ranks/Rank5.png")]

var player : CharacterBody2D

func _ready():
	player = get_parent()
	$Pause.scale = Vector2.ZERO
	$WinScreen.scale = Vector2.ZERO
	$Pause/ButtonRestart.destination = get_tree().current_scene.scene_file_path
	$WinScreen/ButtonRestart.destination = get_tree().current_scene.scene_file_path


func _process(_delta):
	var key_pause : bool = Input.is_action_just_pressed("key_pause")
	if key_pause:
		if $Pause.scale.x < 0.1:
			$Pause/PauseAnim.play("open")
		else:
			$Pause/PauseAnim.play("close")
	
	$TextHealth.text = "%.1f" % player.hp
	if player.heal_effect > 0:
		$TextHealth.text = "%.1f" % player.hp + "+" + "%.1f" % player.heal_effect
	if player.hp / player.maxhp < 0.2:
		$TextHealth/FillerRect.material = load("res://materials/player/player_invincible.tres")
	else:
		$TextHealth/FillerRect.material = load("res://materials/m_quadrille_o1.tres")
	$TextCooldown.text = str(player.cooldown)
	$TextEnergy.text = str(player.energy)
	$TextScore.text = str(player.score)
	$FillerBox/InfoBox/TextFPS.text = "FPS: " + str(floori(Engine.get_frames_per_second()))

	var scale_factor = sin(Time.get_ticks_usec()/100000)/50
	$ImageHealth.scale = Vector2(scale.x + scale_factor, scale.y + scale_factor)
	$ImageCooldown.scale = Vector2(scale.x + scale_factor, scale.y + scale_factor)
	$ImageEnergy.scale = Vector2(scale.x + scale_factor, scale.y + scale_factor)
	$ImageScore.scale = Vector2(scale.x + scale_factor, scale.y + scale_factor)
	$ImageScoreRank.scale = Vector2(scale.x + scale_factor * 2, scale.y - scale_factor)
	$ImageScoreRank.texture = rank_textures[clampi(float(player.score) / float(player.maxscore) * 6, 0, 5)]
	if $OvercountSign.texture.current_frame == 17:
		$OvercountSign.visible = false
	else:
		$OvercountSign.rotation += sin($OvercountSign.texture.current_frame/10)
	
	$FillerBox/InfoBox/TextSpeedrunTimer.text = time_to_speedrun(player.speedrun_time)
	$FillerBox/InfoBox/TextMach.text = "Phase: " + "%.1f" % player.mach
	$FillerBox/InfoBox/TextAutorun.text = "Autorun: " + str(player.autorun)

func time_to_speedrun(t: float) -> String:
	var output : String = "%s:%s:%s"
	output = output % [str(int(t / 3600)), str(int(t / 60) % 60), str(int(t * 1.66) % 100)]
	return output
