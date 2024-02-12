extends CanvasLayer

func _process(_delta):
	$TextHealth.text = "%.1f" % get_parent().hp
	if get_parent().heal_effect > 0:
		$TextHealth.text = "%.1f" % get_parent().hp + "+" + "%.1f" % get_parent().heal_effect
	$TextCooldown.text = str(get_parent().cooldown)
	$TextEnergy.text = str(get_parent().energy)
	$TextScore.text = str(get_parent().score)
	$TextFPS.text = 'FPS: ' + str(floori(Engine.get_frames_per_second()))

	var scale_factor = sin(Time.get_ticks_usec()/100000)/50
	$ImageHealth.scale = Vector2(scale.x + scale_factor, scale.y + scale_factor)
	$ImageCooldown.scale = Vector2(scale.x + scale_factor, scale.y + scale_factor)
	$ImageEnergy.scale = Vector2(scale.x + scale_factor, scale.y + scale_factor)
	$ImageScore.scale = Vector2(scale.x + scale_factor, scale.y + scale_factor)
	
	if $OvercountSign.texture.current_frame == 17:
		$OvercountSign.visible = false
	else:
		$OvercountSign.rotation += sin($OvercountSign.texture.current_frame/10)
