class_name ActionButton
extends Button

@export var action: ActionData
@export var actions_bar: ActionsBar
@export var is_pass_button: bool


func _pressed() -> void:
	actions_bar.clear_action()
	
	if not action:
		if is_pass_button:
			actions_bar.pass_turn()
		return
	
	actions_bar.cancel_button.show()
	actions_bar.current_action = action
	
	actions_bar.next_step()
