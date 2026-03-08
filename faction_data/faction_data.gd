class_name FactionData
extends Resource

enum Faction {
	PIRATES,
	CLERICS,
	ARCHERS,
	DRUIDS,
	MYCOLINGS,
	ROBOTS,
	## No faction, also represents the number of factions
	NONE,
}

@export var faction: Faction = Faction.PIRATES
@export var faction_name: String
@export var main_color: Color
@export var highlight_color: Color
@export var troop_sprite: Texture2D
@export var control_banners: Texture2D
#@export var setup: Array[FactionAction]


func _init(p_faction: Faction = Faction.PIRATES, p_faction_name: String = "",
		p_main_color := Color(0, 0, 0), p_highlight_color := Color(0, 0, 0),
		p_troop_sprite: Texture2D = null, p_control_banners: Texture2D = null) -> void:#,
		#p_setup: Array[FactionAction] = []) -> void:
	faction = p_faction
	faction_name = p_faction_name
	main_color = p_main_color
	highlight_color = p_highlight_color
	troop_sprite = p_troop_sprite
	control_banners = p_control_banners
	#setup = p_setup
