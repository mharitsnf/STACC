extends Node2D


enum { Empty = -1, Ground, Obstacle, CW, CCW } # ijo CW oren CCW

onready var parent : TileMap = get_parent()
onready var spawn_pos = parent.get_node("SpawnPosition")

var move_stack = []
var is_running = false
var is_falling = false
var is_winning = false

signal move_done


func _ready():
	var _e1 = connect("move_done", self, "_on_move_done")
	var _e2 = Globals.connect("reset_level", self, "_on_reset_level")
	
	position = spawn_pos.position


func _process(_delta):
	if not is_running:
		if Input.is_action_just_pressed("run_stack"):
			print(move_stack)
			run_stack()
			return
		
		if Input.is_action_just_pressed("undo") and move_stack.size() > 0:
			run_undo()
			return
	
		var direction = get_input_direction()
		if direction and move_stack.size() < parent.max_stack:
			run_movement(direction)
			return


# Manual movement
func run_movement(direction):
	is_running = true
	
	handle_move(direction)
	yield(self, "move_done")
	
	if is_falling:
		Globals.emit_signal("reset_level")
	
	move_stack.append(direction)
	
	var hud_tween : Tween= parent.add_stack_hud(direction)
	yield(hud_tween, "tween_all_completed")
	
	is_running = false
	
	if is_winning:
		Globals.emit_signal("next_level")


func run_undo():
	is_running = true
	
	var direction = -1 * move_stack.pop_back()
	
	handle_move(direction)
	yield(self, "move_done")
	
	if is_falling:
		Globals.emit_signal("reset_level")
	
	parent.remove_stack_hud('back')
	yield(parent, "remove_stack_done")
	
	is_running = false
	
	if is_winning:
		Globals.emit_signal("next_level")


func run_stack():
	is_running = true
	
	while not move_stack.empty():
		var direction = move_stack.pop_front()
		print(direction)
		
		handle_move(direction)
		yield(self, "move_done")
		
		if is_falling: break
		
		parent.remove_stack_hud()
		yield(parent, "remove_stack_done")
	
	if is_falling:
		Globals.emit_signal("reset_level")
	
	is_running = false
	
	if is_winning:
		Globals.emit_signal("next_level")


func handle_move(direction, undoing = false):
	var next_cell_type = parent.request_next_position(position, direction)
	var falling = false
	
	match next_cell_type:
		Empty:
			# Fall
			move_to(direction)
			yield($Tween, "tween_all_completed")
			fall()
			yield($AnimationPlayer, "animation_finished")
			falling = true
		
		Ground:
			# Move and run move animation
			$AudioController.play_walk()
			move_to(direction)
			yield($Tween, "tween_all_completed")
		
		CW:
			$AudioController.play_walk()
			move_to(direction)
			yield($Tween, "tween_all_completed")
			rotate_stack('CW')
			yield(parent, 'rotate_done')
		
		CCW:
			$AudioController.play_walk()
			move_to(direction)
			yield($Tween, "tween_all_completed")
			rotate_stack('CCW')
			yield(parent, 'rotate_done')
		
		Obstacle:
			hit_obstacle()
			yield($AnimationPlayer, "animation_finished")
	
	var winning = parent.check_win(position)
	emit_signal("move_done", falling, winning)


func move_to(direction):
	var new_pos = parent.map_to_world(parent.world_to_map(position) + direction)
	$Tween.interpolate_property(self, 'position', position, new_pos, .3, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()


func rotate_stack(direction):
	var rotate_amount = 90 if direction == 'CW' else -90
	
	for i in range(move_stack.size()):
		move_stack[i] = move_stack[i].rotated(deg2rad(rotate_amount))
	
	print(move_stack)
	
	parent.rotate_stack_hud(direction)


func hit_obstacle():
	$AnimationPlayer.play("bump")


func fall():
	$AnimationPlayer.play("fall")


func get_input_direction():
	return Vector2(
		int(Input.is_action_just_pressed("right")) - int(Input.is_action_just_pressed("left")),
		int(Input.is_action_just_pressed("down")) - int(Input.is_action_just_pressed("up"))
	)


func _on_reset_level():
	set_physics_process(false)


func _on_move_done(falling, winning):
	is_falling = falling
	is_winning = winning



