class_name Egg
extends Area2D

@export var egg_creature: EggCreature : set = set_egg_creature

@export var age_ticks := 0
@export var temperature := 0.0
@export var lux := 0.0
@export var rotation_ticks_left := 0

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	set_egg_creature(egg_creature)


func set_egg_creature(_egg_creature: EggCreature) -> void:
	egg_creature = _egg_creature
	if is_node_ready():
		sprite_2d.texture = egg_creature.get_egg_texture()
		rotation_ticks_left = egg_creature.ideal_rotation_ticks


func play_crack_animation() -> void:
	var crack_animation_frame_count := 4
	for frame_idx in crack_animation_frame_count:
		sprite_2d.texture = egg_creature.get_egg_texture(frame_idx)
		await get_tree().create_timer(0.25).timeout
