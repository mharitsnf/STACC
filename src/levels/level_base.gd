extends Node2D

export (String) var level_name
export (String) var current_path
export (String) var next_scene

func _ready():
	assert(current_path)
	assert(next_scene)
	
	Globals.current_level_path = current_path
