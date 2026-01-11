class_name RegionData
extends Resource
## A class representing one of the six regions

enum Region {
	RED,
	ORANGE,
	BROWN,
	GREEN,
	MAGENTA,
	SILVER,
}

@export var territories: Array[TerritoryData]
@export var region: Region = Region.RED
