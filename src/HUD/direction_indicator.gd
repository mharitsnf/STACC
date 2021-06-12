extends TextureRect


func _ready():
	self_modulate = Color(1, 1, 1, 0)
	
	$Tween.interpolate_property(self, 'self_modulate', self_modulate, Color(1, 1, 1, 1), .2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.interpolate_property(self, 'rect_position', rect_position, rect_position + Vector2(0, 32), .2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()


func remove():
	$Tween.interpolate_property(self, 'rect_position', rect_position, rect_position - Vector2(0, 32), .2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.interpolate_property(self, 'self_modulate', self_modulate, Color(1, 1, 1, 0), .2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
