class_name Map
extends Sprite2D

enum Action {
	NONE,
	RECRUIT,
	MOVE,
}

const UP := Vector2i(0, -1)
const UP_LEFT := Vector2i(-1, -1)
const DOWN_LEFT := Vector2i(-1, 0)
const DOWN := Vector2i(0, 1)
const DOWN_RIGHT := Vector2i(1, 1)
const UP_RIGHT := Vector2i(1, 0)

@export var hex_scene: PackedScene
@export var territory_shader: Shader

@export var regions: Array[RegionData]
@export var action_buttons: Array[Button]

@export var hex_position_offset := Vector2(-19, -32)
@export var hex_size := Vector2(38, 33)

@export var troop_count_panel: PanelContainer
@export var troop_count_spin_box: SpinBox
@export var troop_count_submit_button: Button

var hexes: Dictionary[Vector2i, Hex] = {}
var territories: Array[TerritoryButton] = []

var current_action: Action = Action.NONE
var move_source: TerritoryButton


func _ready() -> void:
	for region in regions:
		for i in len(region.borders):
			var borders: BorderSet = region.borders[i]
			var territory: TerritoryData = borders.source
			
			var territory_button: TerritoryButton = add_territory_button(borders)
			territory_button.tiles = []
			
			for pos in territory.tiles:
				add_hex(pos)
				territory_button.tiles.append(hexes[pos])
			
			if region.region == RegionData.Region.RED:
				territory_button.add_troops(2)
	
	action_buttons[Action.NONE].pressed.connect(clear_action)
	action_buttons[Action.RECRUIT].pressed.connect(enter_recruit_mode)
	action_buttons[Action.MOVE].pressed.connect(enter_move_mode)
	
	troop_count_panel.hide()


func add_territory_button(borders: BorderSet) -> TerritoryButton:
	var territory: TerritoryData = borders.source
	
	var territory_button := TerritoryButton.new()
	
	territory_button.map = self
	territory_button.territory = territory
	territory_button.borders = borders
	
	var territory_button_material := ShaderMaterial.new()
	territory_button_material.shader = territory_shader
	territory_button.material = territory_button_material
	
	territories.append(territory_button)
	add_child(territory_button)
	
	var silhouette_pos := Vector2(2000, 2000)
	
	# Find the top left corner of the territory to match silhouette pos to territory
	for hex_pos in territory.tiles:
		var physical_pos: Vector2 = to_physical(hex_pos)
		
		if physical_pos.x < silhouette_pos.x:
			silhouette_pos.x = physical_pos.x
		
		if physical_pos.y < silhouette_pos.y:
			silhouette_pos.y = physical_pos.y
	
	# Margin from silhouette not including the territory border
	silhouette_pos += Vector2(1, 1)
	
	territory_button.position = silhouette_pos
	
	return territory_button


func add_hex(pos: Vector2i) -> void:
	var hex: Hex = hex_scene.instantiate()
	
	hexes[pos] = hex
	add_child(hex)
	
	hex.position = to_physical(pos)


func to_physical(pos: Vector2i) -> Vector2:
	var physical: Vector2 = hex_position_offset
	
	physical += Vector2(0, hex_size.y - 1) * pos.y
	physical += Vector2(floori(hex_size.x * 3 / 4), -floori(hex_size.y / 2)) * pos.x
	
	return physical


func clear_action() -> void:
	current_action = Action.NONE
	for territory in territories:
		territory.clear_action_state()
	troop_count_panel.hide()


func enter_recruit_mode() -> void:
	current_action = Action.RECRUIT
	
	for territory in territories:
		if territory.get_troop_count() > 0:
			territory.enter_recruit_mode()


func enter_move_mode() -> void:
	current_action = Action.MOVE
	
	for territory in territories:
		if territory.get_troop_count() > 0:
			territory.enter_move_source_mode()
