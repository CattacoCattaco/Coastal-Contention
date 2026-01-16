class_name ActionsBar
extends VBoxContainer

enum Action {
	NONE,
	RECRUIT,
	MOVE,
}

@export var map: Map

@export var action_buttons: Array[Button]

@export var troop_count_panel: PanelContainer
@export var troop_count_spin_box: SpinBox
@export var troop_count_submit_button: Button

var current_action: Action = Action.NONE
var move_source: TerritoryButton


func _ready() -> void:
	action_buttons[Action.NONE].pressed.connect(clear_action)
	action_buttons[Action.RECRUIT].pressed.connect(enter_recruit_mode)
	action_buttons[Action.MOVE].pressed.connect(enter_move_mode)
	
	clear_action()


func clear_action() -> void:
	current_action = Action.NONE
	for territory in map.territories:
		territory.clear_action_state()
	troop_count_panel.hide()
	action_buttons[Action.NONE].hide()


func enter_recruit_mode() -> void:
	action_buttons[Action.NONE].show()
	
	current_action = Action.RECRUIT
	
	for territory in map.territories:
		if territory.get_troop_count() > 0:
			territory.enter_recruit_mode()


func enter_move_mode() -> void:
	action_buttons[Action.NONE].show()
	
	current_action = Action.MOVE
	
	for territory in map.territories:
		if territory.get_troop_count() > 0:
			territory.enter_move_source_mode()
