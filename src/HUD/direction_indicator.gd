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


func rotate(direction):
	var rotate_amount = 90 if direction == 'CW' else -90
	$Tween.interpolate_property(self, 'rect_rotation', rect_rotation, rect_rotation + rotate_amount, .8, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Tween.start()
