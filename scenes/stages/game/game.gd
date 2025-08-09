extends Control

@export var spawn_scene: PackedScene

var ships_array: Array = []
var damage_obj = {}

var ship_scene = preload("res://scenes/entities/ship/ship.tscn")
var ship_ui_scene = preload("res://scenes/ui/shipUi/shipUi.tscn")


func _ready() -> void:
	for number in range(Globals.player_number):
		var modulateTest = Color(randf(), randf(), randf(), 1.0)
		var newShip: Ship = ship_scene.instantiate()
		newShip.player_index = number
		newShip.name = str(number)
		newShip.modulo = modulateTest
		newShip.position = Vector2((randf() * 1920),( randf() * 1080))
		newShip.rotation = 0.5 *PI * randf() * 2 * PI
		newShip.modulate = modulateTest
		ships_array.append(newShip)
		damage_obj[newShip.name] = 0
		add_child(newShip)
		
		var newHP: Ship_UI = ship_ui_scene.instantiate()
		newHP.max_hp = newShip.health
		newHP.ship_id = newShip.player_index
		newHP.modulo = modulateTest
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
		get_tree().change_scene_to_file("res://scenes/ui/menu/menu.tscn")
	

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
		$NonParalaxBG/Label.text ='player ' + ships_array[0].name + ' ganhou'
		$SpawnTimer.stop()
		get_tree().call_group("Asteroids", "queue_free")
		
			


func _on_start_game_timer_timeout() -> void:
	$SpawnTimer.start()


func _on_spawn_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var spawned_obj: Asteroido = spawn_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $SpawnPath/SpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	spawned_obj.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	spawned_obj.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(50.0, 250.0), 0.0)
	spawned_obj.linear_velocity = velocity.rotated(direction)
	spawned_obj.angular_velocity = randf_range(-5,5)
	var variancia = randf_range(0.7, 1.5)
	spawned_obj.tamanho = spawned_obj.tamanho * variancia
	spawned_obj.mass = spawned_obj.mass * variancia

	# Spawn the mob by adding it to the Main scene.
	add_child(spawned_obj)
	
	#restart the timer with a random value
	$SpawnTimer.start(randf_range(0.5, 5))
