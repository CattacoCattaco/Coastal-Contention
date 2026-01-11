class_name TerritoryData
extends Resource

enum Biome {
	PLAINS,
	SWAMP,
	FOREST,
	MOUNTAINS,
}

const Region = RegionData.Region

@export var region: Region = Region.ORANGE
@export var biome: Biome = Biome.PLAINS
@export var tiles: Array[Vector2i]
