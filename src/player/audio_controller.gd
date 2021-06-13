extends Node


var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()


func play_walk():
	$Walk.pitch_scale = rng.randf_range(.8, 1.5)
	$Walk.play()


func play_use_stack():
	$UseStack.pitch_scale = rng.randf_range(.8, 1.5)
	$UseStack.play()
	return $UseStack


func play_hit_obstacle():
	$HitObstacle.play()
