extends TileMap


enum { Empty = -1, Ground, Obstacle, CW, CCW } # ijo CW oren CCW

const DIRECTION_INDICATOR = preload("res://src/HUD/DirectionIndicator.tscn")
const TILE_ASSET = preload("res://src/asset scene/Tile.tscn")

var label_text = 'moves - '

export var max_stack = 3
export var hud_x_offset = 8

onready var parent = get_parent()
onready var label = parent.get_node("CanvasLayer/Control/Label")
onready var level_name = parent.get_node("CanvasLayer/Control/LevelName")
onready var stack = parent.get_node("CanvasLayer/Control/Stack")
onready var goal = parent.get_node("Goal")
onready var tiles = parent.get_node("Tiles")

signal remove_stack_done
signal rotate_done


func _ready():
	for cell in get_used_cells():
		var gl_pos = map_to_world(cell)
		var type = get_cellv(cell)
		
		var tile = TILE_ASSET.instance()
		tile.position = gl_pos
		
		match type:
			Ground: tile.set_tile('ground') 
			Obstacle: tile.set_tile('obstacle') 
			CW: tile.set_tile('cw')
			CCW: tile.set_tile('ccw')
		
		tiles.add_child(tile)
	
	modulate = Color(1, 1, 1, 0)
	
	label.text = str(max_stack)
	level_name.text = parent.level_name


func check_next_position(pos, direction):
	return get_cellv(world_to_map(pos) + direction)


func check_current_position(pos):
	return get_cellv(world_to_map(pos))


func check_win(pos):
	return world_to_map(pos) == world_to_map(goal.position)


func add_stack_hud(direction):
	var direction_indicator = DIRECTION_INDICATOR.instance()
	direction_indicator.rect_rotation = int(rad2deg(Vector2.ZERO.angle_to_point(direction))) - 90
	
	var stack_child_count = stack.get_child_count()
	if stack_child_count > 0:
		direction_indicator.rect_position = stack.get_child(stack_child_count - 1).rect_position + Vector2(32 + hud_x_offset, -32)
	else:
		direction_indicator.rect_position -= Vector2(0, 32)
	
	stack.add_child(direction_indicator)
	
	var move_count = max_stack - stack.get_child_count()
	if move_count > 0:
		label.text = str(max_stack - stack.get_child_count())
	else:
		label.text = 'LIMIT'
	
	return direction_indicator.get_node("Tween")


func remove_stack_hud(direction = 'front'):
	var idx = stack.get_child_count() - 1 if direction == 'back' else 0
	
	var indicator = stack.get_child(idx)
	indicator.remove()
	yield(indicator.get_node("Tween"), "tween_all_completed")
	
	indicator.queue_free()
	yield(get_tree(), "idle_frame")
	
	var move_count = max_stack - stack.get_child_count()
	if move_count > 0:
		label.text = str(max_stack - stack.get_child_count())
	else:
		label.text = 'LIMIT'
	
	emit_signal("remove_stack_done")


func rotate_stack_hud(direction):
	for child in stack.get_children():
		child.rotate(direction)
	
	yield(get_tree().create_timer(.8), "timeout")
	emit_signal("rotate_done")



