@tool
class_name FactionBox
extends Control

const Faction = TurnOrderBar.Faction

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
	var faction_name: String = TurnOrderBar.FACTION_NAMES[faction]
	var name_alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT
	var faction_color: Color = TurnOrderBar.FACTION_COLORS[faction]
	
	custom_minimum_size.x = font.get_string_size(faction_name, name_alignment, -1, font_size).x + 19
	
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
		var highlight_color: Color = TurnOrderBar.FACTION_HIGHLIGHT_COLORS[faction]
		draw_polyline(corners, highlight_color, 1)


func set_faction(new_faction: Faction) -> void:
	faction = new_faction
	queue_redraw()
