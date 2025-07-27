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

@export var hidden_creature_texture: Texture2D

@onready var choice_items: Array[Control] = [
		%Choice1, %Choice2, %Choice3 ]

var creature_choices: Array[EggCreature] = []
var unlocked_creatures: Dictionary = {}


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
	var label: Label = choice_item.get_node("Label")
	var egg_texture_rect: TextureRect = choice_item.get_node("HBoxContainer/EggTextureRect")
	var creature_texture_rect: TextureRect = choice_item.get_node("HBoxContainer/CreatureTextureRect")
	egg_texture_rect.texture = creature.get_egg_texture()
	if is_unlocked_creature(creature):
		label.text = creature.name
		creature_texture_rect.texture = creature.get_creature_texture()
	else:
		label.text = "???"
		creature_texture_rect.texture = hidden_creature_texture
	
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
	unlocked_creatures.set(creature.name, true)
	creature_choosen.emit(creature)
	self.visible = false


func is_unlocked_creature(creature: EggCreature) -> bool:
	return unlocked_creatures.has(creature.name)
