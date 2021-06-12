extends Node2D


enum { Empty = -1, Ground, Obstacle }

onready var parent : TileMap = get_parent()
onready var spawn_pos = parent.get_node("SpawnPosition")

var move_stack = []
var is_running = false
var is_falling = false

signal move_done

func _ready():
	var _e1 = connect("move_done", self, "_on_move_done")
	var _e2 = Globals.connect("reset_level", self, "_on_reset_level")
	
	position = spawn_pos.position


func _process(_delta):
	if not is_running:
		if Input.is_action_just_pressed("run_stack"):
			run_stack()
			return
	
		var direction = get_input_direction()
		if direction and move_stack.size() < parent.max_stack:
			run_movement(direction)
			parent.add_stack_hud(direction)
			return


func run_movement(direction):
	is_running = true
	
	handle_move(direction)
	yield(self, "move_done")
	
	move_stack.append(direction)
	is_running = false
	
	if is_falling:
		Globals.emit_signal("reset_level")


func run_stack():
	is_running = true
	
	while not move_stack.empty():
		var direction = move_stack.pop_front()
		
		handle_move(direction)
		yield(self, "move_done")
		
		parent.remove_stack_hud()
		yield(get_tree(), "idle_frame")
		
		if is_falling: break
		
		yield(get_tree().create_timer(.2), "timeout")
		
	is_running = false
	
	if is_falling:
		Globals.emit_signal("reset_level")


func handle_move(direction):
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
			move_to(direction)
			yield($Tween, "tween_all_completed")
		
		Obstacle:
			hit_obstacle()
			yield($AnimationPlayer, "animation_finished")
			
	emit_signal("move_done", falling)


func move_to(direction):
	var new_pos = parent.map_to_world(parent.world_to_map(position) + direction)
	$Tween.interpolate_property(self, 'position', position, new_pos, .3, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()


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


func _on_move_done(falling):
	is_falling = falling
