class_name EggCreature
extends Resource

@export var name: String
@export var description: String
@export var sprites: SpriteFrames

@export var ideal_temperature: float
@export var ideal_lux: float
@export var ideal_rotation_ticks: int

## how quickly the egg can heat or cool (°C/tick)
@export var heat_rate: float


func get_creature_texture() -> Texture2D:
	return sprites.get_frame_texture("creature", 0)


func get_egg_texture(frame_idx: int = 0) -> Texture2D:
	return sprites.get_frame_texture("egg", frame_idx)
