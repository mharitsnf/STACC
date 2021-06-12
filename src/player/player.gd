extends Node2D


enum { Empty = -1, Ground, Obstacle }

onready var parent : TileMap = get_parent()
onready var spawn_pos = parent.get_node("SpawnPosition")
onready var current_charge = parent.move_charge

var move_stack = []
var is_running = false


func _ready():
	position = spawn_pos.position


func _process(delta):
	if current_charge > 0 and not is_running:
		if Input.is_action_just_pressed("run_stack"):
			run_stack()
			return
	
		var direction = get_input_direction()
		if direction and current_charge > 0:
			run_movement(direction)


func run_movement(direction):
	is_running = true
	
	var res = handle_move(direction)
	move_stack.append(direction)
	
	current_charge -= 1
	is_running = false
	
	# Reset level
	if not res:
		yield($AnimationPlayer, "animation_finished")
		Globals.emit_signal("reset_level")


func run_stack():
	var res
	is_running = true
	
	while not move_stack.empty():
		var direction = move_stack.pop_front()
		res = handle_move(direction)
		
		if not res: break
		
		yield(get_tree().create_timer(.5), "timeout")
		
	current_charge -= 1
	is_running = false
	
	# Reset level
	if not res:
		yield($AnimationPlayer, "animation_finished")
		Globals.emit_signal("reset_level")


func handle_move(direction):
	var next_cell_type = parent.request_next_position(position, direction)
	match next_cell_type:
		Empty:
			# Fall
			move_to(direction)
			yield($Tween, "tween_all_completed")
			fall()
			return false
		
		Ground:
			# Move and run move animation
			move_to(direction)
			return true
		
		Obstacle:
			hit_obstacle()
			return true


func move_to(direction):
	var new_pos = parent.map_to_world(parent.world_to_map(position) + direction)
	$Tween.interpolate_property(self, 'position', position, new_pos, .3, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")


func hit_obstacle():
	$AnimationPlayer.play("bump")
	yield($AnimationPlayer, "animation_finished")


func fall():
	$AnimationPlayer.play("fall")
	yield($AnimationPlayer, "animation_finished")


func get_input_direction():
	return Vector2(
		int(Input.is_action_just_pressed("right")) - int(Input.is_action_just_pressed("left")),
		int(Input.is_action_just_pressed("down")) - int(Input.is_action_just_pressed("up"))
	)
