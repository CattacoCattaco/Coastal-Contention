class_name ActionButton
extends Button

@export var action: ActionData
@export var actions_bar: ActionsBar
@export var is_pass_button: bool


func _ready() -> void:
	if action:
		text = action._get_name()


func _pressed() -> void:
	if not action:
		actions_bar.clear_action()
		if is_pass_button:
			actions_bar.pass_turn()
		return
	
	var found_valid_territory: bool = false
	var current_player: FactionData.Faction = actions_bar.turn_order_bar.turn_order[0]
	for territory in actions_bar.map.territories:
		if action._is_territory_choice_valid(territory, [], current_player):
			found_valid_territory = true
			break
	
	if not found_valid_territory:
		return
	
	actions_bar.clear_action()
	
	actions_bar.cancel_button.show()
	actions_bar.current_action = action
	
	actions_bar.next_step()
