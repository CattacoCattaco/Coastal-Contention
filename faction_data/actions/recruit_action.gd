class_name RecruitAction
extends ActionData

## How many troops to recruit
@export var recruit_amount: int = 1


func _get_name() -> String:
	return "Recruit"


func _get_instruction(_step: int) -> String:
	return "Choose a territory to recruit in"


func _get_color() -> Color:
	return Color("75a743")


func _get_territory_count() -> int:
	return 1


func _is_territory_choice_valid(territory: TerritoryButton, 
		_others: Array[TerritoryButton], player: FactionData.Faction) -> bool:
	return territory.get_troop_count(player) > 0


func _do_action(territories: Array[TerritoryButton], player: FactionData.Faction) -> void:
	territories[0].add_troops(recruit_amount, player)
