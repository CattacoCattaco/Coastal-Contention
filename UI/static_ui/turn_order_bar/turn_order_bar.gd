class_name TurnOrderBar
extends BoxContainer

const Faction = FactionData.Faction

const FACTION_DATA: Array[FactionData] = [
	preload("res://faction_data/pirates.tres"),
	preload("res://faction_data/clerics.tres"),
	preload("res://faction_data/archers.tres"),
	preload("res://faction_data/druids.tres"),
	preload("res://faction_data/mycolings.tres"),
	preload("res://faction_data/robots.tres"),
]

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
