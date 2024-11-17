extends Node2D


var number_of_ships = 2
var ships_array: Array = []
var damage_obj = {}

var ship_scene = preload("res://scenes/ship/ship.tscn")
var ship_ui_scene = preload("res://scenes/shipUi/shipUi.tscn")


func _ready() -> void:
	for number in range(number_of_ships):
		var newShip: Ship = ship_scene.instantiate()
		newShip.player_index = number
		newShip.name = str(number)
		newShip.position = Vector2(200*(number+1),(200*(number+1)))
		newShip.rotation = 0.5 *PI#randf() * 2 * PI
		ships_array.append(newShip)
		damage_obj[newShip.name] = 0
		add_child(newShip)
		
		var newHP: Ship_UI = ship_ui_scene.instantiate()
		newHP.max_hp = newShip.health
		newHP.ship_id = newShip.player_index
		newHP.position = Vector2(200+(200*(newShip.player_index)),40)
		add_child(newHP)
		
		newShip.change_moves.connect(newHP.setMoves)
		newShip.start_next_move.connect(newHP.playTimer)
		
	for ship: Ship in ships_array:
		ship.start_dmg.connect(add_to_damage)
		ship.stop_dmg.connect(remove_to_damage)
		ship.dead.connect(remove_loosers)
	 

func _process(delta: float) -> void:
	for ship: Ship  in ships_array:
		ship.hit(damage_obj[ship.name] * delta)
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
	

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
			
