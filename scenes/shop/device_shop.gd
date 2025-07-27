extends Control

signal device_bought(device: Node2D)

const COOLER = preload("res://scenes/devices/cooler.tscn")
const HANGING_LAMP = preload("res://scenes/devices/hanging_lamp.tscn")
const HEATER = preload("res://scenes/devices/heater.tscn")
const INCUBATION_STATION = preload("res://scenes/incubation_station.tscn")


func _on_close_button_pressed() -> void:
	self.visible = false


func _on_heater_button_pressed() -> void:
	var device := HEATER.instantiate()
	device_bought.emit(device)
	self.visible = false
	Main.money -= 1


func _on_cooler_button_pressed() -> void:
	var device := COOLER.instantiate()
	device_bought.emit(device)
	self.visible = false
	Main.money -= 2


func _on_incubator_button_pressed() -> void:
	var device := INCUBATION_STATION.instantiate()
	device_bought.emit(device)
	self.visible = false
	Main.money -= 3


func _on_rotator_button_pressed() -> void:
	pass # Replace with function body.


func _on_lamp_button_pressed() -> void:
	var device := HANGING_LAMP.instantiate()
	device_bought.emit(device)
	self.visible = false
	Main.money -= 2


func _on_visibility_changed() -> void:
	if not is_node_ready():
		return
	%HeaterButton.disabled = Main.money < 1
	%CoolerButton.disabled = Main.money < 2
	%LampButton.disabled = Main.money < 2
	%RotatorButton.disabled = Main.money < 2
	%IncubatorButton.disabled = Main.money < 3
