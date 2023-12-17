extends CanvasLayer

func _process(_delta):
	$TextHealth.text = str(float(ceili(get_parent().hp*100))/100)
	$TextCooldown.text = str(get_parent().cooldown)
	$TextEnergy.text = str(get_parent().energy)
	$TextScore.text = str(get_parent().score)

	var scale_factor = sin(Time.get_ticks_usec()/100000)/50
	$ImageHealth.scale = Vector2(scale.x + scale_factor, scale.y + scale_factor)
	$ImageCooldown.scale = Vector2(scale.x + scale_factor, scale.y + scale_factor)
	$ImageEnergy.scale = Vector2(scale.x + scale_factor, scale.y + scale_factor)
	$ImageScore.scale = Vector2(scale.x + scale_factor, scale.y + scale_factor)
	
	if $OvercountSign.texture.current_frame == 17:
		$OvercountSign.visible = false
	else:
		$OvercountSign.rotation += sin($OvercountSign.texture.current_frame/10)
