extends TextureRect


const TEXTURES = [
	"res://assets/arrow-up.png",
	"res://assets/arrow-down.png",
	"res://assets/arrow-left.png",
	"res://assets/arrow-right.png"
]

enum Directions { UP, DOWN, LEFT, RIGHT }
export (Directions) var direction


func _ready():
	var used_path = TEXTURES[direction]
	var tex = load(used_path)
	texture = tex
