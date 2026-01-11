class_name Map
extends Sprite2D

const UP := Vector2i(0, -1)
const UP_LEFT := Vector2i(-1, -1)
const DOWN_LEFT := Vector2i(-1, 0)
const DOWN := Vector2i(0, 1)
const DOWN_RIGHT := Vector2i(1, 1)
const UP_RIGHT := Vector2i(1, 0)

@export var hex_scene: PackedScene

@export var regions: Array[RegionData]

@export var hex_position_offset := Vector2(-19, -32)
@export var hex_size := Vector2(38, 33)

var hexes: Dictionary[Vector2i, Hex] = {}


func _ready() -> void:
	for region in regions:
		for territory in region.territories:
			var territory_button: TerritoryButton = add_territory_button(territory)
			territory_button.tiles = []
			
			for pos in territory.tiles:
				add_hex(pos)
				territory_button.tiles.append(hexes[pos])


func add_territory_button(territory: TerritoryData) -> TerritoryButton:
	var territory_button := TerritoryButton.new()
	
	territory_button.texture_hover = territory.silhouette
	territory_button.texture_pressed = territory.silhouette
	territory_button.texture_click_mask = territory.silhouette_bitmap
	
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
	"res://game_scene/map/territory_data/territories/red/forest.tres"
	
	hexes[pos] = hex
	add_child(hex)
	
	hex.position = to_physical(pos)


func to_physical(pos: Vector2i) -> Vector2:
	var physical: Vector2 = hex_position_offset
	
	physical += Vector2(0, hex_size.y - 1) * pos.y
	physical += Vector2(floori(hex_size.x * 3 / 4), -floori(hex_size.y / 2)) * pos.x
	
	return physical
