extends Node

signal changePlayerCount()
var inputHelper: Serial  = preload("res://scenes/utils/serialize/serialization.gd").new()

var save_path = "user://input_map.json"

func _ready() -> void:
	load_input()

var player_number: int = 2:
	set(newNumber):
			if(newNumber < 2):
				player_number = 2
			else:
				player_number = newNumber
			changePlayerCount.emit()

func load_input():
	if FileAccess.file_exists(save_path):
		print("file found")
		var file = FileAccess.open(save_path, FileAccess.READ)
		var file_text = file.get_as_text()
		inputHelper.deserialize_inputs_for_actions(file_text)
	else:
		print("file not found")


func save_input():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(inputHelper.serialize_inputs_for_actions())
