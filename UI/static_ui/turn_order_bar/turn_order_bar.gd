class_name TurnOrderBar
extends BoxContainer

enum Faction {
	PIRATES,
	MYCOLINGS,
	ROBOTS,
	## No faction, also represents the number of factions
	NONE,
}

const FACTION_NAMES: Dictionary[Faction, String] = {
	Faction.PIRATES: "Pirates",
	Faction.MYCOLINGS: "Mycolings",
	Faction.ROBOTS: "Robots",
}

const FACTION_COLORS: Dictionary[Faction, Color] = {
	Faction.PIRATES: Color("a53030"),
	Faction.MYCOLINGS: Color("a23e8c"),
	Faction.ROBOTS: Color("577277"),
}

const FACTION_TROOPS: Dictionary[Faction, Texture2D] = {
	Faction.PIRATES: preload("res://hex/piece/troop/pirate.png"),
	Faction.MYCOLINGS: preload("res://hex/piece/troop/mycoling.png"),
}

const FACTION_BANNERS: Dictionary[Faction, Texture2D] = {
	Faction.PIRATES: preload("res://hex/control_banners/pirate_banners.png"),
	Faction.MYCOLINGS: preload("res://hex/control_banners/mycoling_banners.png"),
}

@export var faction_box_scene: PackedScene

var turn_order: Array[Faction]
var faction_boxes: Array[FactionBox]


func _ready() -> void:
	faction_boxes = []
	turn_order = [
			Faction.PIRATES,
			Faction.MYCOLINGS,
	]
	
	for faction in turn_order:
		var faction_box: FactionBox = faction_box_scene.instantiate()
		
		faction_boxes.append(faction_box)
		add_child(faction_box)
		
		faction_box.set_faction(faction)


func next_turn() -> void:
	turn_order.append(turn_order.pop_front())
	
	for i in len(faction_boxes):
		var faction: Faction = turn_order[i]
		var faction_box: FactionBox = faction_boxes[i]
		
		faction_box.set_faction(faction)
