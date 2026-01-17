class_name FactionBox
extends ColorRect

const Faction = TurnOrderBar.Faction

@export var name_label: Label

var faction: Faction


func set_faction(new_faction: Faction) -> void:
	faction = new_faction
	name_label.text = TurnOrderBar.FACTION_NAMES[faction]
	color = TurnOrderBar.FACTION_COLORS[faction]
	
	await RenderingServer.frame_post_draw
	
	custom_minimum_size.x = name_label.size.x + 20
