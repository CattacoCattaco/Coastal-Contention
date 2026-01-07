class_name StaticUI
extends Control
## A class for the holder of all of the ui that stays in a fixed position relative to the camera

@export var map: Sprite2D
@export var camera: Camera2D


func _ready() -> void:
	_update_size()
	get_viewport().size_changed.connect(_update_size)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			camera.position = clamp_to_bounds(camera.position - event.relative)


func _update_size() -> void:
	custom_minimum_size = get_viewport_rect().size


func clamp_to_bounds(pos: Vector2) -> Vector2:
	var new_pos: Vector2 = pos
	var map_size: Vector2 = map.texture.get_size()
	var viewport_size: Vector2 = get_viewport_rect().size
	
	var bottom_right_bound = (map_size - viewport_size) / 2
	
	if viewport_size.x > map_size.x:
		new_pos.x = 0
	elif pos.x < -bottom_right_bound.x:
		new_pos.x = -bottom_right_bound.x
	elif pos.x > bottom_right_bound.x:
		new_pos.x = bottom_right_bound.x
	
	if viewport_size.y > map_size.y:
		new_pos.y = 0
	elif pos.y < -bottom_right_bound.y:
		new_pos.y = -bottom_right_bound.y
	elif pos.y > bottom_right_bound.y:
		new_pos.y = bottom_right_bound.y
	
	return new_pos
