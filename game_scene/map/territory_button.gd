class_name TerritoryButton
extends TextureButton

enum ActionState {
	NONE,
	RECRUIT,
}

var map: Map
var tiles: Array[Hex]
var territory: TerritoryData
var borders: BorderSet

var is_currently_hovered: bool = false
var is_currently_pressed: bool = false

var current_action_state: ActionState = ActionState.NONE


func _ready() -> void:
	disabled = true
	
	button_down.connect(_button_down)
	button_up.connect(_button_up)
	mouse_entered.connect(_button_hovered)
	mouse_exited.connect(_button_unhovered)
	
	texture_normal = territory.silhouette
	texture_click_mask = territory.silhouette_bitmap
	
	update_state_alpha()
	clear_action_state()
	
	self_modulate = Color(1, 1, 1, 0)
	var territory_sprite := Sprite2D.new()
	territory_sprite.texture = territory.silhouette
	
	add_child(territory_sprite)
	
	territory_sprite.centered = false
	territory_sprite.position = Vector2(0, 0)
	
	territory_sprite.material = material


func _button_hovered() -> void:
	is_currently_hovered = true
	update_state_alpha()


func _button_unhovered() -> void:
	is_currently_hovered = false
	update_state_alpha()


func _button_down() -> void:
	is_currently_pressed = true
	update_state_alpha()


func _button_up() -> void:
	is_currently_pressed = false
	update_state_alpha()


func update_state_alpha() -> void:
	var shader_material: ShaderMaterial = material
	
	if is_currently_pressed:
		shader_material.set_shader_parameter("alpha", 0.5)
	elif is_currently_hovered:
		shader_material.set_shader_parameter("alpha", 0.25)
	else:
		shader_material.set_shader_parameter("alpha", 0.0)


func clear_action_state() -> void:
	disabled = true
	current_action_state = ActionState.NONE
	set_border(Color(0, 0, 0, 0))


func enter_recruit_mode() -> void:
	disabled = false
	current_action_state = ActionState.RECRUIT
	set_border(Color("75a743"))


func set_border(color: Color) -> void:
	var shader_material: ShaderMaterial = material
	shader_material.set_shader_parameter("outline_color", color)


func _pressed() -> void:
	match current_action_state:
		ActionState.RECRUIT:
			add_troops(1)
			map.clear_action()


func add_troops(amount: int) -> void:
	tiles[0].add_troops(amount)


func get_troop_count() -> int:
	return tiles[0].troop_count
