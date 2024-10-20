extends RichTextLabel

func _process(delta: float) -> void:
	if visible_ratio < 1:
		visible_ratio += 0.003 * 60 * delta
