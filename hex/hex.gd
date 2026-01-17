class_name Hex
extends Sprite2D

const Faction = TurnOrderBar.Faction

@export var troop_sprite: Sprite2D
@export var troop_count_label: Label
@export var control_banners: Sprite2D

var troop_count: int = 0
var faction: Faction


func _ready() -> void:
	update_troop_count_label()
	control_banners.hide()


func add_troops(amount: int) -> void:
	troop_count += amount
	update_troop_count_label()


func update_troop_count_label() -> void:
	troop_count_label.text = str(troop_count)
	if troop_count > 0:
		troop_sprite.show()
		troop_count_label.show()
		
		troop_sprite.texture = TurnOrderBar.FACTION_TROOPS[faction]
	else:
		troop_sprite.hide()
		troop_count_label.hide()
