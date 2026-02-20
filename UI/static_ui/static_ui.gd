class_name StaticUI
extends Control
## A class for the holder of all of the ui that stays in a fixed position relative to the camera


func _ready() -> void:
	_update_size()
	get_viewport().size_changed.connect(_update_size)


func _update_size() -> void:
	custom_minimum_size = get_viewport_rect().size
