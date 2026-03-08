@abstract
class_name ActionData
extends Resource

## The name of the action (Used by action button)
@abstract func _get_name() -> String

## What to say when choosing the [param step]th territory
@abstract func _get_instruction(step: int) -> String

## Color of highlighting for this action
@abstract func _get_color() -> Color

## The number of territories that must be selected for this action
## [br](EX: 1 for recruiting and 2 for moving)
@abstract func _get_territory_count() -> int

## Can [param territory] be chosen by [param player] given that
## [param others] were chosen before it?
@abstract func _is_territory_choice_valid(territory: TerritoryButton, 
		others: Array[TerritoryButton], player: FactionData.Faction) -> bool

## Does the action
@abstract func _do_action(territories: Array[TerritoryButton], player: FactionData.Faction) -> void
