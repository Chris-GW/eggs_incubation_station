@tool
class_name TemperatureBar
extends Control

@export var temp_range: float = 20.0 : set = set_temp_range
@export var prefered_temp: Vector2 : set = set_prefered_temp
@export var value: float = IncubationStation.AMBIENT_TEMP

@onready var cold_temperature: TextureProgressBar = $ColdTemperature
@onready var hot_temperature: TextureProgressBar = $HotTemperature


func _ready() -> void:
	adjust_temp_range()


func _process(delta: float) -> void:
	if cold_temperature.min_value >= value or value >= cold_temperature.max_value:
		adjust_temp_range()
	$Cursor/ValueLabel.text = "%2d °C" % value
	set_position_for_temp($Cursor, value)


func set_position_for_temp(control: Control, temp: float) -> void:
	var min_temp := cold_temperature.min_value
	var max_temp := cold_temperature.max_value
	var width := cold_temperature.size.x
	var percent := (temp - min_temp) / (max_temp - min_temp)
	var cursor_x := width * percent
	cursor_x -= control.size.x / 2.0
	cursor_x = clampf(cursor_x, 24.0, width - control.size.x)
	control.position = Vector2(cursor_x, control.position.y)


func adjust_temp_range() -> void:
	cold_temperature.min_value = value - temp_range
	cold_temperature.max_value = value + temp_range
	hot_temperature.min_value = cold_temperature.min_value
	hot_temperature.max_value = cold_temperature.max_value
	
	cold_temperature.value = prefered_temp.x
	hot_temperature.value = prefered_temp.y
	if cold_temperature.value == cold_temperature.min_value:
		hot_temperature.value += 2.0
	if hot_temperature.value == cold_temperature.max_value:
		cold_temperature.value -= 2.0
	
	$PreferedLabel.text = "%d°C - %d°C" % [prefered_temp.x, prefered_temp.y]
	var preferd_mid_temp := (prefered_temp.x + prefered_temp.y) / 2.0
	set_position_for_temp($PreferedLabel, preferd_mid_temp)


func set_temp_range(_temp_range: float) -> void:
	temp_range = _temp_range
	if is_node_ready():
		adjust_temp_range()


func set_prefered_temp(_prefered_temp: Vector2) -> void:
	prefered_temp = _prefered_temp
	if is_node_ready():
		adjust_temp_range()
