class_name ActionsBar
extends VBoxContainer

const Faction = FactionData.Faction

@export var map: Map
@export var turn_order_bar: TurnOrderBar

@export var cancel_button: ActionButton
@export var action_buttons: Array[ActionButton]

@export var troop_count_panel: PanelContainer
@export var troop_count_spin_box: SpinBox
@export var troop_count_submit_button: Button

@export var instruction_label: Label

var current_action: ActionData = null
var current_action_step: int = 0
var chosen_territories: Array[TerritoryButton] = []
var move_source: TerritoryButton


func _ready() -> void:
	clear_action()
	instruction_label.hide()


func clear_action() -> void:
	current_action = null
	current_action_step = 0
	chosen_territories = []
	for territory in map.territories:
		territory.clear_action_state()
	troop_count_panel.hide()
	cancel_button.hide()
	instruction_label.hide()


func next_step() -> void:
	for territory in map.territories:
		territory.clear_action_state()
	
	current_action_step += 1
	
	var player: FactionData.Faction = turn_order_bar.turn_order[0]
	
	if current_action_step > current_action._get_territory_count():
		instruction_label.hide()
		@warning_ignore("redundant_await")
		await current_action._do_action(chosen_territories, player)
		clear_action()
		return
	
	instruction_label.show()
	instruction_label.text = current_action._get_instruction(current_action_step)
	
	for territory in map.territories:
		if current_action._is_territory_choice_valid(territory, chosen_territories, player):
			territory.enter_action_mode()


func pass_turn() -> void:
	turn_order_bar.next_turn()
