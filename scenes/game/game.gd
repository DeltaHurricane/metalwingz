extends Node2D


var number_of_ships = 2
var ships_array: Array = []
var damage_obj = {}

var ship_scene = preload("res://scenes/ship/ship.tscn")


func _ready() -> void:
	for number in range(number_of_ships):
		var newShip: Ship = ship_scene.instantiate()
		newShip.name = str(number)
		newShip.position = Vector2(-500,(-300*(number+2)))
		ships_array.append(newShip)
		damage_obj[newShip.name] = 0
		add_child(newShip)
	for ship: Ship in ships_array:
		ship.start_dmg.connect(add_to_damage)
		ship.stop_dmg.connect(remove_to_damage)
		ship.dead.connect(remove_loosers)
			
	 

func _process(delta: float) -> void:
	for ship: Ship  in ships_array:
		ship.hit(damage_obj[ship.name] * delta)
	if(ships_array.size() > 1):
		$Label.text = str(ships_array[0].health)
	

func add_to_damage(ship:Node2D):
	if (ship is Ship):
		damage_obj[ship.name] += 1
	

func remove_to_damage(ship:Node2D):
	if (ship is Ship):
		damage_obj[ship.name] -= 1
	
func remove_loosers(name:String):
	for number in range(ships_array.size()):
		if (ships_array[number].name == name):
			ships_array.remove_at(number)
			break
	if(ships_array.size() == 1):
		$Label.text = ships_array[0].name + ' ganhou'
			
