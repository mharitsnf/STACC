extends Control
class_name MenuScreen

export (String) var level_name
export (String) var current_path
export (String) var next_scene

func _ready():
	assert(current_path)
	assert(next_scene)
	
	Globals.current_level_path = current_path


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		Globals.emit_signal("next_level")
