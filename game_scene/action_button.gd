class_name ActionButton
extends Button

@export var action: ActionData
@export var actions_bar: ActionsBar


func _pressed() -> void:
	actions_bar.clear_action()
	
	if not action:
		return
	
	actions_bar.cancel_button.show()
	actions_bar.current_action_data = action
	
	actions_bar.next_step()
