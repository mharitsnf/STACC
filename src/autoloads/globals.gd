extends Node

var output : TextureRect
var viewport : Viewport
var output_player : AnimationPlayer
var root

var current_level_path = "res://src/levels/LevelTest1.tscn"

signal reset_level
signal next_level

func _unused():
	emit_signal("reset_level")
	emit_signal("next_level")
