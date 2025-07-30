extends Control

signal creature_choosen(creature: EggCreature)

var creatures: Array[EggCreature] = [
	preload("res://scripts/egg_creatures/creature_bison.tres"),
	preload("res://scripts/egg_creatures/creature_blue_bird.tres"),
	preload("res://scripts/egg_creatures/creature_bunny.tres"),
	preload("res://scripts/egg_creatures/creature_cat.tres"),
	preload("res://scripts/egg_creatures/creature_chicken.tres"),
	preload("res://scripts/egg_creatures/creature_duck.tres"),
	preload("res://scripts/egg_creatures/creature_fish.tres"),
	preload("res://scripts/egg_creatures/creature_lion.tres"),
	preload("res://scripts/egg_creatures/creature_monky.tres"),
	preload("res://scripts/egg_creatures/creature_pig.tres"),
	preload("res://scripts/egg_creatures/creature_snake.tres"),
	preload("res://scripts/egg_creatures/creature_turtle.tres"),
]


func _ready() -> void:
	randomize_choices()


func randomize_choices() -> void:
	var creature_choices: Array[EggCreature] = []
	creature_choices.append_array(creatures)
	creature_choices.shuffle()
	
	for idx in range(%ChoiceContainer.get_child_count()):
		var creature: EggCreature = creature_choices.get(idx)
		var choice_button: EggChoiceButton = %ChoiceContainer.get_child(idx)
		choice_button.set_egg_creature(creature)


func _on_creature_choosen(creature: EggCreature) -> void:
	creature_choosen.emit(creature)
