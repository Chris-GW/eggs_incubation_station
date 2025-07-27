class_name Main
extends Node2D

const EGG = preload("res://scenes/egg.tscn")

@onready var game_tick_timer: Timer = $GameTickTimer

static var money := 1
var game_ticks := 0


func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	if $CanvasLayer/ClearSpawnArea.visible and not $SpawnArea2D.has_overlapping_areas():
		$CanvasLayer/ClearSpawnArea.visible = false


func _on_game_tick_timer_timeout() -> void:
	get_tree().call_group("devices", "pre_game_tick")
	get_tree().call_group("devices", "next_game_tick")
	get_tree().call_group("devices", "post_game_tick")
	game_ticks += 1
	%TickLabel.text = "Ticks: %6d" % game_ticks


func _on_open_shop_button_pressed() -> void:
	if $SpawnArea2D.has_overlapping_areas():
		$CanvasLayer/ClearSpawnArea.visible = true
	else:
		%DeviceShop.visible = true


var current_station: IncubationStation

func _on_egg_selection_wanted(incubation_station: IncubationStation) -> void:
	current_station = incubation_station
	%EggReward.randomize_choices()
	%EggReward.visible = true


func _on_egg_reward_creature_choosen(creature: EggCreature) -> void:
	current_station._on_egg_reward_creature_choosen(creature)


func _on_device_shop_device_bought(device: Node2D) -> void:
	$Map.add_child(device)
	device.global_position = %Marker2D.global_position
