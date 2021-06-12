extends TileMap


const DIRECTION_INDICATOR = preload("res://src/HUD/DirectionIndicator.tscn")

export var level_name = ''
export var max_stack = 3

export (String) var current_path
export (String) var next_scene


func _ready():
	assert(current_path)
	
	Globals.current_level_path = current_path
	$CanvasLayer/Control/Label.text = str(max_stack)


func request_next_position(pos, direction):
	return get_cellv(world_to_map(pos) + direction)


func check_win(pos):
	return world_to_map(pos) == world_to_map($Goal.position)


func add_stack_hud(direction):
	var dir_idx = 0
	match direction:
		Vector2.UP:
			dir_idx = 0
		Vector2.DOWN:
			dir_idx = 1
		Vector2.LEFT:
			dir_idx = 2
		Vector2.RIGHT:
			dir_idx = 3
	
	var direction_indicator = DIRECTION_INDICATOR.instance()
	direction_indicator.direction = dir_idx
	$CanvasLayer/Control/HBoxContainer.add_child(direction_indicator)


func remove_stack_hud(target = 'front'):
	var idx = $CanvasLayer/Control/HBoxContainer.get_child_count() - 1 if target == 'back' else 0
	$CanvasLayer/Control/HBoxContainer.get_child(idx).queue_free()
