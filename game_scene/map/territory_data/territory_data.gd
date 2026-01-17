@tool
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
@export var biome_marker_pos: Vector2i
@export var silhouette: Texture2D:
	set(value):
		silhouette = value
		generate_silhouette_bitmap()

## GENERATED AUTOMATICALLY[br]DO NOT CHANGE MANUALLY
@export var silhouette_bitmap: BitMap


func generate_silhouette_bitmap() -> void:
	silhouette_bitmap = BitMap.new()
	silhouette_bitmap.create_from_image_alpha(silhouette.get_image())
