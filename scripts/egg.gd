class_name Egg
extends Area2D

const HATCHING_EGG = preload("res://scenes/hatching_egg.tscn")

@export var egg_creature: EggCreature : set = set_egg_creature

@export var age_ticks := 0
@export var temperature := 0.0
@export var light_level := EggCreature.LightLevel.DARK
@export var ticks_since_last_rotation := 0
@export var happiness := 0.0
@export var growth_ticks := 0

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	set_egg_creature(egg_creature)


func set_egg_creature(_egg_creature: EggCreature) -> void:
	egg_creature = _egg_creature
	if is_node_ready():
		sprite_2d.texture = egg_creature.get_egg_texture()


func play_crack_animation() -> void:
	var crack_animation_frame_count := 4
	for frame_idx in crack_animation_frame_count:
		sprite_2d.texture = egg_creature.get_egg_texture(frame_idx)
		await get_tree().create_timer(0.25).timeout


func is_good_temp() -> bool:
	var min_temp := egg_creature.preferred_temp_range.x
	var max_temp := egg_creature.preferred_temp_range.y
	return min_temp <= temperature and temperature <= max_temp

func is_good_light_level() -> bool:
	return light_level == egg_creature.preferred_light_level

func is_good_rotation() -> bool:
	var allowed_deviation := 3.0
	var difference := ticks_since_last_rotation - egg_creature.preferred_rotation_interval
	return abs(difference) <= allowed_deviation

func is_happy_enough() -> bool:
	return happiness >= egg_creature.happiness_threshold

func is_ready_to_hatch() -> bool:
	return growth_ticks >= egg_creature.growth_duration


func hatch_egg() -> void:
	var hatching_egg := HATCHING_EGG.instantiate()
	hatching_egg.get_node("UpperEggshellSprite").texture = egg_creature.get_egg_texture(5)
	hatching_egg.get_node("LowerEggshellSprite").texture = egg_creature.get_egg_texture(6)
	hatching_egg.get_node("CreatureSprite").texture = egg_creature.get_creature_texture()
	self.add_sibling(hatching_egg)
	hatching_egg.global_position = global_position
	queue_free()
