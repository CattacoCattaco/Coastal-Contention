class_name AttackScreen
extends ColorRect

signal finished()
signal _finished_roll()

const Faction = FactionData.Faction

@export var camera: DraggableCamera
@export var attack_dice_label: Label
@export var defense_dice_label: Label
@export var attack_dice: Array[TextureRect]
@export var defense_dice: Array[TextureRect]

var dice_finished_rolling: int


func _ready() -> void:
	hide()


func do_attack(territory: TerritoryButton, attacker: Faction, defender: Faction) -> void:
	dice_finished_rolling = 0
	
	show()
	
	if Random.use_big_dice(camera):
		attack_dice_label.label_settings.font_size = 32
		attack_dice_label.custom_minimum_size.x = 340
		defense_dice_label.custom_minimum_size.x = 340
		attack_dice[0].custom_minimum_size.y = 72
		defense_dice[0].custom_minimum_size.y = 72
	else:
		attack_dice_label.label_settings.font_size = 16
		attack_dice_label.custom_minimum_size.x = 170
		defense_dice_label.custom_minimum_size.x = 170
		attack_dice[0].custom_minimum_size.y = 36
		defense_dice[0].custom_minimum_size.y = 36
	
	var attacker_troops: int = territory.get_troop_count(attacker)
	var defender_troops: int = territory.get_troop_count(defender)
	
	var attack_rolls: int = min(attacker_troops, 4)
	var defense_rolls: int = min(defender_troops, 5)
	
	for i in len(attack_dice):
		var attack_die: TextureRect = attack_dice[i]
		
		if i >= attack_rolls:
			attack_die.hide()
			dice_finished_rolling += 1
		else:
			attack_die.show()
	
	for i in len(defense_dice):
		var defense_die: TextureRect = defense_dice[i]
		
		if i >= defense_rolls:
			defense_die.hide()
			dice_finished_rolling += 1
		else:
			defense_die.show()
	
	var attack_roll_values: Array[int] = []
	var defense_roll_values: Array[int] = []
	
	var attack_hits: int = 0
	var defense_hits: int = 0
	
	for i in range(attack_rolls):
		var roll: int = Random.roll_die()
		
		attack_roll_values.append(roll)
		if roll >= 3:
			attack_hits += 1
		
		_roll_die(attack_dice[i], roll)
	
	for i in range(defense_rolls):
		var roll: int = Random.roll_die()
		
		defense_roll_values.append(roll)
		if roll >= 4:
			defense_hits += 1
		
		_roll_die(defense_dice[i], roll)
	
	await _finished_roll
	
	print("Attack rolls: ", attack_roll_values)
	print("Defense rolls: ", defense_roll_values)
	print("Attack hits: ", attack_hits)
	print("Defense hits: ", defense_hits)
	
	# Players nock out eachother's pieces
	territory.remove_troops(attack_hits, defender)
	territory.remove_troops(defense_hits, attacker)
	
	await get_tree().create_timer(2).timeout
	
	hide()
	finished.emit()


func _roll_die(die: TextureRect, end_value: int) -> void:
	var roll_length: int = Random.randomi_range(3, 20)
	
	var previous_roll: int = 0
	
	for i in range(roll_length):
		var new_roll: int = Random.roll_die()
		while new_roll == previous_roll:
			new_roll = Random.roll_die()
		
		die.texture = Random.get_die_sprite(new_roll, camera)
		
		new_roll = previous_roll
		
		await get_tree().create_timer(0.25 if i < roll_length else 0.5).timeout
	
	die.texture = Random.get_die_sprite(end_value, camera)
	
	dice_finished_rolling += 1
	if dice_finished_rolling == len(attack_dice) + len(defense_dice):
		_finished_roll.emit()
