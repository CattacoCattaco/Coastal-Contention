class_name TerritoryButton
extends TextureButton

@export var tiles: Array[Hex]


func _ready() -> void:
	button_down.connect(_button_down)
	button_up.connect(_button_up)
	mouse_entered.connect(_button_hovered)


func _button_hovered() -> void:
	self_modulate = Color(1, 1, 1, 0.25)


func _button_down() -> void:
	self_modulate = Color(1, 1, 1, 0.5)


func _button_up() -> void:
	self_modulate = Color(1, 1, 1, 0.25)


func _pressed() -> void:
	tiles[0].add_troops(1)
