extends HBoxContainer


func _ready() -> void:
	$VBoxContainer/Label.text = str(Globals.player_number)
	Globals.changePlayerCount.connect(changeLabel)


func _on_add_pressed() -> void:
	Globals.player_number += 1
	
func _on_remove_pressed() -> void:
	Globals.player_number -= 1

func changeLabel()-> void:
	$VBoxContainer/Label.text = str(Globals.player_number)
