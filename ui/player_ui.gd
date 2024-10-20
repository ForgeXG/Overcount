extends CanvasLayer

var rank_textures = [preload("res://ui/ui_sprites/ranks/Rank0.png"),
preload("res://ui/ui_sprites/ranks/Rank1.png"),
preload("res://ui/ui_sprites/ranks/Rank2.png"),
preload("res://ui/ui_sprites/ranks/Rank3.png"),
preload("res://ui/ui_sprites/ranks/Rank4.png"),
preload("res://ui/ui_sprites/ranks/Rank5.png")]

var player : Player

func _ready():
	player = get_parent()
	$Pause.scale = Vector2.ZERO
	$WinScreen.scale = Vector2.ZERO
	$WinScreen.show()
	$LossScreen.scale = Vector2.ZERO
	$LossScreen.show()
	$Pause/ButtonRestart.destination = get_tree().current_scene.scene_file_path
	$WinScreen/ButtonRestart.destination = get_tree().current_scene.scene_file_path
	$DialogueBox/TextDialogue.visible_ratio = 0

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
	if player.dmg_effect > 0:
		$TextHealth/FillerRect.material = load("res://materials/player/player_invincible.tres")
	else:
		$TextHealth/FillerRect.material = load("res://materials/m_quadrille_o1.tres")
	$TextCooldown.text = str(player.cooldown)
	$TextEnergy.text = str(player.energy)
	$TextScore.text = str(player.score)
	$TextCharge.text = str(int(player.special_charge))
	$FillerBox/InfoBox/TextFPS.text = "FPS: " + str(floori(Engine.get_frames_per_second()))

	var scale_factor = sin(Time.get_ticks_usec()/100000)/50
	$ImageHealth.scale = Vector2(scale.x + scale_factor, scale.y + scale_factor) / scale.x
	$ImageCooldown.scale = Vector2(scale.x + scale_factor, scale.y + scale_factor) / scale.x
	$ImageEnergy.scale = Vector2(scale.x + scale_factor, scale.y + scale_factor) / scale.x
	$ImageScore.scale = Vector2(scale.x + scale_factor, scale.y + scale_factor) / scale.x
	$ImageScoreRank.scale = Vector2(scale.x + scale_factor * 2, scale.y - scale_factor) / scale.x
	$ImageScoreRank.texture = rank_textures[clampi(float(player.score) / float(player.maxscore) * 6, 0, 5)]
	$ImageCharge.material.set_shader_parameter("anglelimit",
	 TAU * player.special_charge / player.weapon.special_points)
	if $OvercountSign.texture.current_frame == 17:
		$OvercountSign.visible = false
	else:
		$OvercountSign.rotation += sin($OvercountSign.texture.current_frame/10)
	
	$FillerBox/InfoBox/TextSpeedrunTimer.text = time_to_speedrun(player.speedrun_time)
	$FillerBox/InfoBox/TextMach.text = "Phase: " + "%.1f" % player.mach
	$FillerBox/InfoBox/TextAutorun.text = "Auto: " + str(G.autorun)
	$FillerBox/InfoBox/TextDPS.text = "DPS: " + str("%.1f" % player.dps)
	$FillerBox/InfoBox/TextDebug.text = str(player.debug_float)
	# Dialogue
	var dl = player.dialogue
	var ph = dl.phrases[dl.phrase_ind]
	$DialogueBox/TextureRect.texture = ph.char_sprites[ph.char_ind]
	$DialogueBox/TextDialogue.text = ph.text # Can also add ph.characters[ph.char_ind] before
	if $DialogueBox/TextDialogue.visible_characters < ph.text.length():
		$DialogueBox/TextDialogue.visible_characters += 1
	# if $DialogueBox/TextDialogue.visible_ratio < 1:
		# $DialogueBox/TextDialogue.visible_ratio = clamp($DialogueBox/TextDialogue.visible_ratio + 0.02, 0, 1)

func time_to_speedrun(t: float) -> String:
	var output : String = "%s:%s:%s"
	output = output % [str(int(t / 3600)), str(int(t / 60) % 60), str(int(t * 1.66) % 100)]
	return output
