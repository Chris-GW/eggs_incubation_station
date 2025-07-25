class_name Egg
extends Area2D

@export var egg_creature: EggCreature : set = set_egg_creature

@export var age_ticks := 0
@export var growth_stage := 0 : set = set_growth_stage
@export var temperature := 0.0
@export var lux := 0.0
@export var rotation_ticks_left := 0

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	set_egg_creature(egg_creature)


func set_egg_creature(_egg_creature: EggCreature) -> void:
	egg_creature = _egg_creature
	if is_node_ready():
		sprite_2d.texture = egg_creature.get_egg_texture(growth_stage)
		rotation_ticks_left = egg_creature.ideal_rotation_ticks


func set_growth_stage(_growth_stage) -> void:
	growth_stage = _growth_stage
	if is_node_ready():
		sprite_2d.texture = egg_creature.get_egg_texture(growth_stage)
