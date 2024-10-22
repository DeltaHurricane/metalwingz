extends Control

func _on_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")


func _on_test_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/testScene/main.tscn")


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
