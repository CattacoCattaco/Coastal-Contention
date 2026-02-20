extends Node

var rng := RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()


func roll_die() -> int:
	return rng.randi_range(1, 6)
	
