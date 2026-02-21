extends Node

const DIE_SPRITES_32: Array[Texture] = [
	preload("res://random/die/32px/die_0.png"),
	preload("res://random/die/32px/die_1.png"),
	preload("res://random/die/32px/die_2.png"),
	preload("res://random/die/32px/die_3.png"),
	preload("res://random/die/32px/die_4.png"),
	preload("res://random/die/32px/die_5.png"),
	preload("res://random/die/32px/die_6.png"),
	preload("res://random/die/32px/die_7.png"),
	preload("res://random/die/32px/die_8.png"),
	preload("res://random/die/32px/die_9.png"),
]

const DIE_SPRITES_64: Array[Texture] = [
	preload("res://random/die/64px/die_0.png"),
	preload("res://random/die/64px/die_1.png"),
	preload("res://random/die/64px/die_2.png"),
	preload("res://random/die/64px/die_3.png"),
	preload("res://random/die/64px/die_4.png"),
	preload("res://random/die/64px/die_5.png"),
	preload("res://random/die/64px/die_6.png"),
	preload("res://random/die/64px/die_7.png"),
	preload("res://random/die/64px/die_8.png"),
	preload("res://random/die/64px/die_9.png"),
]

var rng := RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()


func roll_die() -> int:
	return randomi_range(1, 6)


func get_die_sprite(roll: int, camera: DraggableCamera) -> Texture2D:
	if use_big_dice(camera):
		return DIE_SPRITES_64[roll]
	else:
		return DIE_SPRITES_32[roll]


func use_big_dice(camera: DraggableCamera) -> bool:
	var viewport_size: Vector2 = camera.get_viewport_rect().size
	return viewport_size.x >= 1000 and viewport_size.y >= 600


func randomi_range(a: int, b: int) -> int:
	return rng.randi_range(a, b)
