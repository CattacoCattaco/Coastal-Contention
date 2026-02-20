class_name DraggableCamera
extends Camera2D

@export var map: Map
@export var static_ui: StaticUI


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			position = clamp_to_bounds(position - event.relative)
			static_ui.position = position - static_ui.size / 2.0


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
