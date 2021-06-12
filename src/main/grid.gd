extends TileMap


export var level_name = ''
export var max_stack = 3
export (String) var level_path


func _ready():
	assert(level_path)
	
	Globals.current_level_path = level_path
	$CanvasLayer/Control/Label.text = str(max_stack)


func request_next_position(pos, direction):
	return get_cellv(world_to_map(pos) + direction)
