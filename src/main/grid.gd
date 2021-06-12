extends TileMap


export var level_name = ''
export var move_charge = 3


func request_next_position(pos, direction):
	return get_cellv(world_to_map(pos) + direction)
