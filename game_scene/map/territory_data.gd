class_name TerritoryData
extends Resource

enum Biome {
	PLAINS,
	SWAMP,
	FOREST,
	MOUNTAIN,
}

@export var continent: Map.Continent = Map.Continent.ORANGE
@export var biome: Biome = Biome.PLAINS
@export var tiles: Array[Vector2i]
