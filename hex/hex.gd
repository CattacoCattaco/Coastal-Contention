class_name Hex
extends Sprite2D

@export var troop_sprite: Sprite2D
@export var troop_count_label: Label

var troop_count: int = 0


func _ready() -> void:
	update_troop_count_label()


func add_troops(amount: int) -> void:
	troop_count += amount
	update_troop_count_label()


func update_troop_count_label() -> void:
	troop_count_label.text = str(troop_count)
	if troop_count > 0:
		troop_sprite.show()
		troop_count_label.show()
	else:
		troop_sprite.hide()
		troop_count_label.hide()
