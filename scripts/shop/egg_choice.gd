class_name EggChoiceButton
extends Button

signal creature_choosen(creature: EggCreature)

@export var egg_creature: EggCreature : set = set_egg_creature
@export var hidden_creature_texture: Texture2D

@onready var creature_name: Label = %CratureName
@onready var egg_texture_rect: TextureRect = %EggTextureRect
@onready var creature_texture_rect: TextureRect = %CreatureTextureRect
@onready var temp_label: Label = %TempLabel
@onready var light_label: Label = %LightLabel
@onready var rotation_label: Label = %RotationLabel
@onready var money_label: Label = %MoneyLabel
@onready var growth_label: Label = %GrowthLabel


func set_egg_creature(_egg_creature: EggCreature) -> void:
	egg_creature = _egg_creature
	if is_node_ready():
		update_information()


func update_information() -> void:
	if Main.is_unlocked_creature(egg_creature):
		creature_name.text = egg_creature.name
		creature_texture_rect.texture = egg_creature.get_creature_texture()
	else:
		creature_name.text = "???"
		creature_texture_rect.texture = hidden_creature_texture
	egg_texture_rect.texture = egg_creature.get_egg_texture()
	
	var min_temp := egg_creature.preferred_temp_range.x
	var max_temp := egg_creature.preferred_temp_range.y
	temp_label.text = "%02d-%02d °C" % [min_temp, max_temp]
	light_label.text = EggCreature.light_level_name(egg_creature.preferred_light_level)
	rotation_label.text = "%02ds" % egg_creature.preferred_rotation_interval
	money_label.text = str(egg_creature.sell_value)
	growth_label.text = str(egg_creature.growth_duration)


func _on_pressed() -> void:
	creature_choosen.emit(egg_creature)
