class_name Map
extends Sprite2D

const Faction = TurnOrderBar.Faction

const UP := Vector2i(0, -1)
const UP_LEFT := Vector2i(-1, -1)
const DOWN_LEFT := Vector2i(-1, 0)
const DOWN := Vector2i(0, 1)
const DOWN_RIGHT := Vector2i(1, 1)
const UP_RIGHT := Vector2i(1, 0)

@export var hex_scene: PackedScene
@export var territory_shader: Shader

@export var actions_bar: ActionsBar
@export var turn_order_bar: TurnOrderBar

@export var regions: Array[RegionData]

@export var hex_position_offset := Vector2(-19, -32)
@export var hex_size := Vector2(38, 33)

var hexes: Dictionary[Vector2i, Hex] = {}
var territories: Array[TerritoryButton] = []


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
				territory_button.add_troops(2, Faction.PIRATES)
			elif region.region == RegionData.Region.MAGENTA:
				territory_button.add_troops(2, Faction.MYCOLINGS)


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
