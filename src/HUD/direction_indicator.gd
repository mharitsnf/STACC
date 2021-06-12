extends TextureRect


const TEXTURES = [
	"res://assets/arrow-up.png",
	"res://assets/arrow-down.png",
	"res://assets/arrow-right.png",
	"res://assets/arrow-left.png"
]
enum ArrowDirections { UP, DOWN, RIGHT, LEFT }
export (ArrowDirections) var arrow_direction


func _ready():
	var tex = load(TEXTURES[arrow_direction])
	texture = tex
	self_modulate = Color(1, 1, 1, 0)
	
	$Tween.interpolate_property(self, 'self_modulate', self_modulate, Color(1, 1, 1, 1), .2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.interpolate_property(self, 'rect_position', rect_position, rect_position + Vector2(0, 32), .2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()


func remove():
	$Tween.interpolate_property(self, 'rect_position', rect_position, rect_position - Vector2(0, 32), .2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.interpolate_property(self, 'self_modulate', self_modulate, Color(1, 1, 1, 0), .2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
