extends TileMap


const DIRECTION_INDICATOR = preload("res://src/HUD/DirectionIndicator.tscn")

export var level_name = ''
export var max_stack = 3

export (String) var current_path
export (String) var next_scene

signal remove_stack_done


func _ready():
	assert(current_path)
	
	Globals.current_level_path = current_path
	$CanvasLayer/Control/Label.text = str(max_stack)


func request_next_position(pos, direction):
	return get_cellv(world_to_map(pos) + direction)


func check_win(pos):
	return world_to_map(pos) == world_to_map($Goal.position)


func add_stack_hud(direction):
	var stack = $CanvasLayer/Control/Stack
	
	var direction_indicator = DIRECTION_INDICATOR.instance()
	
	match direction:
		Vector2.UP: direction_indicator.arrow_direction = 0
		Vector2.DOWN: direction_indicator.arrow_direction = 1
		Vector2.RIGHT: direction_indicator.arrow_direction = 2
		Vector2.LEFT: direction_indicator.arrow_direction = 3
	
	var stack_child_count = stack.get_child_count()
	if stack_child_count > 0:
		direction_indicator.rect_position = stack.get_child(stack_child_count - 1).rect_position + Vector2(32, -32)
	else:
		direction_indicator.rect_position -= Vector2(0, 32)
	
	stack.add_child(direction_indicator)
	return direction_indicator.get_node("Tween")


func remove_stack_hud(direction = 'front'):
	var stack = $CanvasLayer/Control/Stack
	var idx = stack.get_child_count() - 1 if direction == 'back' else 0
	
	var indicator = stack.get_child(idx)
	indicator.remove()
	yield(indicator.get_node("Tween"), "tween_all_completed")
	
	indicator.queue_free()
	yield(get_tree(), "idle_frame")
	
	emit_signal("remove_stack_done")
