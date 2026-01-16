class_name TerritoryButton
extends TextureButton

enum ActionState {
	NONE,
	RECRUIT,
	MOVE_SOURCE,
	MOVE_END,
}

var map: Map
var actions_bar: ActionsBar
var tiles: Array[Hex]
var territory: TerritoryData
var borders: BorderSet

var is_currently_hovered: bool = false
var is_currently_pressed: bool = false

var current_action_state: ActionState = ActionState.NONE


func _ready() -> void:
	actions_bar = map.actions_bar
	
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


func enter_move_source_mode() -> void:
	disabled = false
	current_action_state = ActionState.MOVE_SOURCE
	set_border(Color("73bed3"))


func enter_move_end_mode() -> void:
	disabled = false
	current_action_state = ActionState.MOVE_END
	set_border(Color("73bed3"))


func set_border(color: Color) -> void:
	var shader_material: ShaderMaterial = material
	shader_material.set_shader_parameter("outline_color", color)


func _pressed() -> void:
	match current_action_state:
		ActionState.RECRUIT:
			add_troops(1)
			actions_bar.clear_action()
		ActionState.MOVE_SOURCE:
			actions_bar.clear_action()
			actions_bar.current_action = ActionsBar.Action.MOVE
			actions_bar.move_source = self
			
			for territory_button in map.territories:
				if territory_button.territory not in borders.connections:
					continue
				
				territory_button.enter_move_end_mode()
		ActionState.MOVE_END:
			actions_bar.clear_action()
			actions_bar.current_action = ActionsBar.Action.MOVE
			actions_bar.troop_count_panel.show()
			
			var move_source: TerritoryButton = actions_bar.move_source
			
			actions_bar.troop_count_spin_box.min_value = 1
			actions_bar.troop_count_spin_box.max_value = move_source.get_troop_count()
			actions_bar.troop_count_spin_box.value = 1
			
			var submit_button: Button = actions_bar.troop_count_submit_button
			for connection in submit_button.pressed.get_connections():
				submit_button.pressed.disconnect(connection["callable"])
			
			submit_button.pressed.connect(move_source.move_from_troop_count_panel.bind(self))


## Move troops from this territory to [param to] in an amount based on the
## value of the troop count panel's spin box.
func move_from_troop_count_panel(to: TerritoryButton) -> void:
	var amount: int = roundi(actions_bar.troop_count_spin_box.value)
	
	move_troops(amount, to)
	
	actions_bar.clear_action()


## Move [param amount] troops to [to]
func move_troops(amount: int, to: TerritoryButton) -> void:
	add_troops(-amount)
	to.add_troops(amount)


func add_troops(amount: int) -> void:
	tiles[0].add_troops(amount)


func get_troop_count() -> int:
	return tiles[0].troop_count
