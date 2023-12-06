extends Node

var rocket = preload("res://scenes/rocket.tscn")

@onready var player: Area2D = $Player
@onready var rocket_positioner_right: Node2D = $Player/RocketPositionerRight
@onready var rocket_positioner_left: Node2D = $Player/RocketPositionerLeft
@onready var level_manager: Node = $LevelManager
@onready var main_menu: Control = $MainMenu
@onready var level_text: Label = $LevelText

var start_position := Vector2(320,500)
var current_level := 0

func _ready() -> void:
	level_text.hide()
	main_menu.show()
	get_tree().paused = true
	
	player.global_position = start_position


func _on_player_shoot() -> void:
	var rocket_left = rocket.instantiate()
	var rocket_right = rocket.instantiate()
	add_child(rocket_left)
	add_child(rocket_right)
	rocket_left.position = rocket_positioner_left.global_position
	rocket_right.position = rocket_positioner_right.global_position


func _on_main_menu_start() -> void:
	level_text.show()
	level_manager.start()
	_on_player_shoot()


func _on_player_game_over() -> void:
	for i in get_children():
		if i.to_string() == "rocket":
			i.queue_free()
	
	level_text.hide()
	main_menu.show()
	get_tree().paused = true
	
	player.global_position = start_position
	player.rotation_degrees = 0
	
	current_level -= 1 # to account for the checkpoint bridge
	
	level_manager.reset()
	level_manager._ready()


func _on_player_slow_down() -> void:
	level_manager.speed -= 6


func _on_player_speed_up() -> void:
	level_manager.speed += 6


func _on_level_manager_checkpoint() -> void:
	current_level += 1
	level_text.text = "Level " + str(current_level)
