extends Control


func _on_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/stages/game/game.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/options/game_menu.tscn")

func _on_multiplayer_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/stages/multiplayer/multiplayer.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
