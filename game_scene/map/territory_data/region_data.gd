class_name RegionData
extends Resource
## A class representing one of the six regions

enum Region {
	RED,
	GOLD,
	BROWN,
	GREEN,
	MAGENTA,
	SILVER,
}

@export var borders: Array[BorderSet]
@export var region: Region = Region.RED
