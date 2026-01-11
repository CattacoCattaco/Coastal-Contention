class_name Map
extends Sprite2D

enum Continent {
	RED,
	ORANGE,
	BROWN,
	GREEN,
	MAGENTA,
	GREY,
}

const UP := Vector2i(0, -1)
const UP_LEFT := Vector2i(-1, -1)
const DOWN_LEFT := Vector2i(-1, 0)
const DOWN := Vector2i(0, 1)
const DOWN_RIGHT := Vector2i(1, 1)
const UP_RIGHT := Vector2i(1, 0)

@export var hex_scene: PackedScene

@export var territories: Array[TerritoryData]

@export var hex_position_offset := Vector2(-19, -32)
@export var hex_size := Vector2(38, 33)

var hexes: Dictionary[Vector2i, Hex] = {}


func _ready() -> void:
	for territory in territories:
		for pos in territory.tiles:
			add_hex(pos)


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
