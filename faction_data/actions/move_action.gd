class_name MoveAction
extends ActionData


func _get_name() -> String:
	return "Move"


func _get_instruction(step: int) -> String:
	match step:
		0:
			return "Choose a territory to move from"
		1:
			return "Choose a territory to move to"
	
	return ""


func _get_color() -> Color:
	return Color("73bed3")


func _get_territory_count() -> int:
	return 2


func _is_territory_choice_valid(territory: TerritoryButton, 
		others: Array[TerritoryButton], player: FactionData.Faction) -> bool:
	if not others:
		return territory.is_valid_move_source(player)
	else:
		return territory.is_valid_move_end(player, others[0])


func _do_action(territories: Array[TerritoryButton], player: FactionData.Faction) -> void:
	var move_source: TerritoryButton = territories[0]
	var move_end: TerritoryButton = territories[1]
	
	var troop_count_panel: PanelContainer = move_source.actions_bar.troop_count_panel
	var troop_count_spin_box: SpinBox = move_source.actions_bar.troop_count_spin_box
	
	troop_count_panel.show()
	
	troop_count_spin_box.min_value = 1
	troop_count_spin_box.max_value = move_source.get_troop_count(player)
	troop_count_spin_box.value = 1
	
	var submit_button: Button = move_source.actions_bar.troop_count_submit_button
	#for connection in submit_button.pressed.get_connections():
		#submit_button.pressed.disconnect(connection["callable"])
	
	await submit_button.pressed
	
	move_source.move_from_troop_count_panel(move_end, player)
