class_name MapCamera
extends Camera2D

@export var map: Sprite2D

var view_size := Vector2(640, 360)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			position = clamp_to_bounds(position - event.relative)


func clamp_to_bounds(pos: Vector2) -> Vector2:
	var new_pos: Vector2 = pos
	var map_size: Vector2 = map.texture.get_size()
	var bottom_right_bound = (map_size - view_size) / 2
	
	if pos.x < -bottom_right_bound.x:
		new_pos.x = -bottom_right_bound.x
	elif pos.x > bottom_right_bound.x:
		new_pos.x = bottom_right_bound.x
	
	if pos.y < -bottom_right_bound.y:
		new_pos.y = -bottom_right_bound.y
	elif pos.y > bottom_right_bound.y:
		new_pos.y = bottom_right_bound.y
	
	return new_pos
