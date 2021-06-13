extends Node


var mounted_level
var is_processing = false


func _ready():
	Globals.output = $Output
	Globals.output_player = $Output/AnimationPlayer
	Globals.viewport = $ViewportContainer/Viewport
	
	var _e1 = Globals.connect("reset_level", self, '_on_reset_level')
	var _e2 = Globals.connect("next_level", self, '_on_next_level')
	
	mounted_level = $ViewportContainer/Viewport.get_child(0)
	check_play_song()


func _on_reset_level():
	if not is_processing:
		is_processing = true
		
		Globals.output_player.play('hide')
		yield(Globals.output_player, "animation_finished")
		
		Globals.viewport.get_child(0).queue_free()
		yield(get_tree(), "idle_frame")
		
		var reloaded_level = load(Globals.current_level_path).instance()
		Globals.viewport.add_child(reloaded_level)
		yield(get_tree(), "idle_frame")
		
		check_play_song()
		
		Globals.output_player.play('show')
		yield(Globals.output_player, "animation_finished")
		
		is_processing = false


func _on_next_level():
	if not is_processing:
		is_processing = true
		
		Globals.output_player.play('hide')
		yield(Globals.output_player, "animation_finished")
		
		var current_level = Globals.viewport.get_child(0)
		var next_scene_path = current_level.next_scene
		current_level.queue_free()
		yield(get_tree(), "idle_frame")
		
		var new_scene = load(next_scene_path).instance()
		Globals.viewport.add_child(new_scene)
		mounted_level = new_scene
		yield(get_tree(), "idle_frame")
		
		check_play_song()
		
		Globals.output_player.play('show')
		yield(Globals.output_player, "animation_finished")
		
		is_processing = false


func check_play_song():
	if mounted_level is MenuScreen:
		if $MainSong.playing:
			$MainSong.stop()
		
		if not $MenuSong.playing:
			$MenuSong.play()
	
	if mounted_level is LevelScreen:
		if $MenuSong.playing:
			$MenuSong.stop()
		
		if not $MainSong.playing:
			$MainSong.play()

