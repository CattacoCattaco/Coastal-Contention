@tool
class_name FactionBox
extends Control

const Faction = FactionData.Faction

@export_tool_button("Redraw") var redraw_from_editor: Callable = queue_redraw

@export var attack_button: Button

var faction: Faction
var attackable: bool = false:
	set(value):
		attackable = value
		if attackable:
			attack_button.show()
		else:
			attack_button.hide()
		queue_redraw()


func _ready() -> void:
	attack_button.hide()
	faction = TurnOrderBar.Faction.PIRATES
	queue_redraw()


func _draw() -> void:
	var font: Font = theme.default_font
	var font_size: int = theme.default_font_size
	var name_pos := Vector2(10, custom_minimum_size.y + font_size) / 2
	var faction_data: FactionData = TurnOrderBar.FACTION_DATA[faction]
	var faction_name: String = faction_data.faction_name
	var name_alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT
	var faction_color: Color = faction_data.main_color
	
	custom_minimum_size.x = font.get_string_size(faction_name, name_alignment, -1, font_size).x + 10
	
	draw_rect(Rect2(Vector2.ZERO, custom_minimum_size), faction_color)
	draw_string(font, name_pos, faction_name, name_alignment, -1, font_size)
	
	if attackable:
		var corners := PackedVector2Array([
			Vector2(0.5, 0.5),
			Vector2(0.5, custom_minimum_size.y - 0.5),
			Vector2(custom_minimum_size.x - 0.5, custom_minimum_size.y - 0.5),
			Vector2(custom_minimum_size.x - 0.5, 0.5),
			Vector2(0.5, 0.5),
		])
		var highlight_color: Color = faction_data.highlight_color
		draw_polyline(corners, highlight_color, 1)


func set_faction(new_faction: Faction) -> void:
	faction = new_faction
	queue_redraw()
