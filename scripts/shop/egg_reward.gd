extends Control

signal creature_choosen(creature: EggCreature)

var creatures: Array[EggCreature] = [
	preload("res://scripts/egg_creatures/creature_chicken.tres"),
	preload("res://scripts/egg_creatures/creature_duck.tres"),
	preload("res://scripts/egg_creatures/creature_fish.tres"),
]

@onready var choice_items: Array[Control] = [
		%Choice1, %Choice2, %Choice3 ]
		
var creature_choices: Array[EggCreature] = []


func _ready() -> void:
	randomize_choices()


func randomize_choices() -> void:
	creature_choices = []
	creature_choices.append_array(creatures)
	creature_choices.shuffle()
	
	for idx in range(choice_items.size()):
		var creature: EggCreature = creature_choices.get(idx)
		var choice_item: Control = choice_items.get(idx)
		setup_creature_choice(choice_item, creature)


func setup_creature_choice(choice_item: Control, creature: EggCreature) -> void:
	choice_item.get_node("Label").text = creature.name
	choice_item.get_node("HBoxContainer/EggTextureRect").texture = creature.get_egg_texture()
	choice_item.get_node("HBoxContainer/CreatureTextureRect").texture = creature.get_creature_texture()
	var information := """
	Temp: %d - %d
	Light Level: %s
	Rotations: %d
	""" % [creature.preferred_temp_range.x, creature.preferred_temp_range.y,
			creature.preferred_light_level,
			creature.preferred_rotation_interval
	]
	choice_item.get_node("InformationLabel").text = information


func _on_button_pressed(idx: int) -> void:
	var creature: EggCreature = creature_choices.get(idx)
	creature_choosen.emit(creature)
	$".".visible = false
