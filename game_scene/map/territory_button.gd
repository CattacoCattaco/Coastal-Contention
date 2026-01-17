class_name TerritoryButton
extends TextureButton

enum ActionState {
	NONE,
	RECRUIT,
	MOVE_SOURCE,
	MOVE_END,
}

const Faction = TurnOrderBar.Faction

var map: Map
var turn_order_bar: TurnOrderBar
var actions_bar: ActionsBar
var territory: TerritoryData
var borders: BorderSet

var neighbors: Array[TerritoryButton]

var tiles: Array[Hex]
var biome_marker_hex: Hex

var is_currently_hovered: bool = false
var is_currently_pressed: bool = false

var current_action_state: ActionState = ActionState.NONE

var controller: Faction = Faction.NONE


func _ready() -> void:
	turn_order_bar = map.turn_order_bar
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
	
	for other_territory in map.territories:
		if other_territory.territory in borders.connections:
			neighbors.append(other_territory)
			other_territory.neighbors.append(self)


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
	var faction: Faction = turn_order_bar.turn_order[0]
	
	match current_action_state:
		ActionState.RECRUIT:
			add_troops(1, faction)
			actions_bar.clear_action()
		ActionState.MOVE_SOURCE:
			actions_bar.clear_action()
			actions_bar.action_buttons[ActionsBar.Action.NONE].show()
			actions_bar.current_action = ActionsBar.Action.MOVE
			actions_bar.move_source = self
			
			for neighbor in neighbors:
				if controller == faction or neighbor.controller == faction:
					neighbor.enter_move_end_mode()
		ActionState.MOVE_END:
			actions_bar.clear_action()
			actions_bar.action_buttons[ActionsBar.Action.NONE].show()
			actions_bar.current_action = ActionsBar.Action.MOVE
			actions_bar.troop_count_panel.show()
			
			var move_source: TerritoryButton = actions_bar.move_source
			
			actions_bar.troop_count_spin_box.min_value = 1
			actions_bar.troop_count_spin_box.max_value = move_source.get_troop_count(faction)
			actions_bar.troop_count_spin_box.value = 1
			
			var submit_button: Button = actions_bar.troop_count_submit_button
			for connection in submit_button.pressed.get_connections():
				submit_button.pressed.disconnect(connection["callable"])
			
			submit_button.pressed.connect(
					move_source.move_from_troop_count_panel.bind(self, faction))


## Move troops from this territory to [param to] in an amount based on the
## value of the troop count panel's spin box.
func move_from_troop_count_panel(to: TerritoryButton, faction: Faction) -> void:
	var amount: int = roundi(actions_bar.troop_count_spin_box.value)
	
	move_troops(amount, to, faction)
	
	actions_bar.clear_action()


## Move [param amount] troops to [to]
func move_troops(amount: int, to: TerritoryButton, faction: Faction) -> void:
	add_troops(-amount, faction)
	to.add_troops(amount, faction)


func add_troops(amount: int, faction: Faction) -> void:
	if amount == 0:
		return
	
	for tile in tiles:
		if tile.faction == faction or tile.troop_count == 0:
			tile.faction = faction
			tile.add_troops(amount)
			check_control_change(faction, amount > 0)
			return


func check_control_change(faction: Faction, increased: bool) -> void:
	if increased and faction != controller:
		if get_troop_count(faction) > get_troop_count(controller):
			set_controller(faction)
	elif faction == controller and not increased:
		for other_faction: Faction in Faction.values():
			if get_troop_count(other_faction) > get_troop_count(controller):
				set_controller(other_faction)
			elif get_troop_count(other_faction) == get_troop_count(controller):
				if controller != faction:
					remove_controller()
		
		if get_troop_count(controller) == 0:
			remove_controller()


func get_troop_count(faction: Faction) -> int:
	if faction == Faction.NONE:
		return 0
	
	var troop_count: int = 0
	for tile in tiles:
		if tile.faction == faction:
			troop_count += tile.troop_count
	
	return troop_count


func set_controller(faction: Faction) -> void:
	controller = faction
	
	biome_marker_hex.control_banners.show()
	biome_marker_hex.control_banners.texture = TurnOrderBar.FACTION_BANNERS[controller]


func remove_controller() -> void:
	controller = Faction.NONE
	biome_marker_hex.control_banners.hide()
