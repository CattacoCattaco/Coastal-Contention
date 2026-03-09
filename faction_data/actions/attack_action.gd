class_name AttackAction
extends ActionData


func _get_name() -> String:
	return "Attack"


func _get_instruction(_step: int) -> String:
	return "Choose a territory to attack in"


func _get_color() -> Color:
	return Color("a53030")


func _get_territory_count() -> int:
	return 1


func _is_territory_choice_valid(territory: TerritoryButton, 
		_others: Array[TerritoryButton], player: FactionData.Faction) -> bool:
	return territory.can_attack(player)


func _do_action(territories: Array[TerritoryButton], player: FactionData.Faction) -> void:
	var territory: TerritoryButton = territories[0]
	
	for faction_box in territory.turn_order_bar.faction_boxes:
		if faction_box.faction == player or territory.get_troop_count(faction_box.faction) == 0:
			continue
		
		faction_box.attackable = true
		
		for connection in faction_box.attack_button.pressed.get_connections():
			faction_box.attack_button.pressed.disconnect(connection["callable"])
		
		var do_attack: Callable = territory.do_attack.bind(player, faction_box.faction)
		faction_box.attack_button.pressed.connect(do_attack)
