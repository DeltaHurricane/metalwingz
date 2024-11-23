extends Control


func _ready() -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/Label.text = str(Globals.player_number)
	Globals.changePlayerCount.connect(changeLabel)

func _on_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_multiplayer_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/multiplayer/multiplayer.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_add_pressed() -> void:
	Globals.player_number += 1
	
func _on_remove_pressed() -> void:
	Globals.player_number -= 1

func changeLabel()-> void:
	$MarginContainer/VBoxContainer/HBoxContainer/Label.text = str(Globals.player_number)
