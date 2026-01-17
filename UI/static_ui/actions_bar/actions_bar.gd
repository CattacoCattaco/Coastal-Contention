class_name ActionsBar
extends VBoxContainer

enum Action {
	NONE,
	RECRUIT,
	MOVE,
	PASS,
}

const Faction = TurnOrderBar.Faction

@export var map: Map
@export var turn_order_bar: TurnOrderBar

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
	action_buttons[Action.PASS].pressed.connect(pass_turn)
	
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
		if territory.get_troop_count(turn_order_bar.turn_order[0]) > 0:
			territory.enter_recruit_mode()


func enter_move_mode() -> void:
	var faction: Faction = turn_order_bar.turn_order[0]
	
	action_buttons[Action.NONE].show()
	
	current_action = Action.MOVE
	
	for territory in map.territories:
		if territory.get_troop_count(faction) == 0:
			continue
		
		if territory.controller == faction:
			territory.enter_move_source_mode()
		else:
			for neighbor in territory.neighbors:
				if neighbor.controller == faction:
					territory.enter_move_source_mode()
					break


func pass_turn() -> void:
	clear_action()
	turn_order_bar.next_turn()
