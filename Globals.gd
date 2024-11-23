extends Node

signal changePlayerCount()

var player_number: int = 2:
	set(newNumber):
			if(newNumber < 2):
				player_number = 2
			else:
				player_number = newNumber
			changePlayerCount.emit()
