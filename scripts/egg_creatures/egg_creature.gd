class_name EggCreature
extends Resource

enum LightLevel { DARK, DIMM, BRIGHT, }

@export var name: String
@export var description: String
@export var sprites: SpriteFrames

@export_category("Growth Conditions")
## Acceptable temperature range (°C) where the egg remains happy.
## Vector2(x = min_temperature, y = max_temperature)
@export var preferred_temp_range: Vector2
## Preferred ambient light level for optimal egg happiness
@export var preferred_light_level: LightLevel
## Ideal time (in ticks) between each required rotation for the egg to remain happy
@export var preferred_rotation_interval: int

## How quickly the egg absorbs or loses heat (°C per tick)
@export var heat_rate: float
## Rate of happiness change per tick (positive or negative)
@export var happiness_rate: float
## Minimum happiness level (0–100) required for the egg to grow
@export var happiness_threshold: float
## Total time (in ticks) the egg needs to grow before it can hatch
@export var growth_duration: int
@export var sell_value := 1


func get_creature_texture() -> Texture2D:
	return sprites.get_frame_texture("creature", 0)


func get_egg_texture(frame_idx: int = 0) -> Texture2D:
	return sprites.get_frame_texture("egg", frame_idx)


static func light_level_name(light_level: LightLevel) -> String:
	var light_name: String = LightLevel.keys()[light_level]
	return light_name.capitalize()
