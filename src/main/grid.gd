extends TileMap

export var move_charge = 3


func _ready():
	Globals.connect("reset_level", self, "_on_reset_level")


func request_next_position(pos, direction):
	return get_cellv(world_to_map(pos) + direction)


func _on_reset_level():
	print('aaa')
	$Player.is_running = true
	$Player.position = $SpawnPosition.position
	$Player.current_charge = move_charge
	$Player/Sprite.scale = Vector2(0.5, 0.5)
	$Player.is_running = false
