extends Node

func _ready():
	Globals.output = $Output
	Globals.output_player = $Output/AnimationPlayer
	Globals.viewport = $ViewportContainer/Viewport
	
	var _e = Globals.connect("reset_level", self, '_on_reset_level')

func _on_reset_level():
	Globals.output_player.play('hide')
	yield(Globals.output_player, "animation_finished")
	
	Globals.viewport.get_child(0).queue_free()
	yield(get_tree(), "idle_frame")
	
	var reloaded_level = load(Globals.current_level_path).instance()
	Globals.viewport.add_child(reloaded_level)
	
	Globals.output_player.play('show')
	yield(Globals.output_player, "animation_finished")
