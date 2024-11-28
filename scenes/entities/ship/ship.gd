extends RigidBody2D
class_name Ship

signal start_dmg(body: Node2D)
signal stop_dmg(body: Node2D)
signal dead(name: String)
signal change_ship_hp(new_hp: float)
signal change_moves(moves: Array[ShipMove])
signal start_next_move(time: float)

var current_move: ShipMove = ShipMove.create(ShipMove.Moves.RETO)
var colisionImunity: bool = false

var next_move_ready: bool = true
var curr_shield: Shields = null


@export var player_index: int = 0
@export var health:float = 3.0
@export var radarHeight:float = 0.7
@export var radarWidth:float = 1.1
@export var max_speed:int = 300 # How fast the player will move (pixels/sec).

var shield_object = preload("./shields/shields.tscn")
var granada_object = preload("res://scenes/entities/granada/granada.tscn")


func _process(delta: float) -> void:
	apply_central_impulse(Vector2(Vector2.UP.rotated(rotation) * current_move.move[ShipMove.Dir.FORCE]  * delta))
	apply_torque_impulse(current_move.move[ShipMove.Dir.TORQUE]  * delta)
	
	if(health <= 0):
		dead.emit(self.name)
		queue_free()
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var leng: int = min(max_speed, state.linear_velocity.length())
	state.linear_velocity = state.linear_velocity.normalized() * leng
	
func hit(dano: float) -> void:
	health -= dano
	AutoloadedSignals.change_ship_hp.emit(player_index,health)

func granada(_activationTime:float):
	var newGranada: Granada = granada_object.instantiate()
	newGranada.position = self.position + (Vector2.UP.rotated(rotation) * Vector2(0,-12))
	get_parent().add_child(newGranada)

func shields(activationTime:float):
	lock_rotation = true
	var newShield: Shields = shield_object.instantiate()
	add_child(newShield)
	newShield.activate(activationTime)
	newShield.remove.connect(removeShield)
	
	
func removeShield():
	lock_rotation = false
	if(curr_shield):
		curr_shield.queue_free()
		curr_shield = null
	
	
func _on_radar_body_entered(body: Node2D) -> void:
		start_dmg.emit(body)
		#print((body.global_position.distance_to(global_position)))
		#print(body)
		#print(body.has_signal('teste'))
		#if(body.has_method('teste')):
			#body.teste.emit()

func _on_radar_body_exited(body: Node2D) -> void:
		stop_dmg.emit(body)
		#print((body.global_position.distance_to(global_position)))
		#print(body)

func disableRadar(time:float) -> void:
	var radar: Radar = $Radar
	radar.disable_radar(time)

func on_colision(damage: float) -> void: 
	disableRadar(2.0)

	if(colisionImunity == false and damage > 0):
		colisionImunity = true
		hit(damage)
		$ColisionImunity.start()
		

func _unhandled_input(event: InputEvent) -> void:
	if(next_move_ready):
		#if event is InputEventKey and event.pressed:
		if Input.is_action_pressed("spec"+str(player_index)):
			add_move(get_special_move())
			return
		if Input.is_action_pressed("fast"+str(player_index)):
			add_move(get_secondary_move())
		else:
			add_move(get_move())
		#else:
			#if event is InputEventJoypadButton and event.pressed:
				#if Input.is_joy_button_pressed(player_index-1,JOY_BUTTON_B):
					#add_move(get_special_move2())
					#return
				#if Input.is_joy_button_pressed(player_index-1,JOY_BUTTON_A):
					#add_move(get_secondary_move2())
				#else:
					#add_move(get_move2())
				#

func _on_next_move_timeout() -> void:
	next_move_ready = true
	current_move = ShipMove.create(ShipMove.Moves.RETO)
	change_moves.emit(null)
	$ShipBody2/ColldownSprite.hide()
	
func add_move(move_obj:ShipMove) -> void:
	if move_obj != null:
		next_move_ready = false
		$ShipBody2/ColldownSprite.show()
		current_move = (move_obj)
		change_moves.emit(current_move)
		start_next_move.emit(current_move.move['time'])
		$NextMove.start(current_move.move['time'])
		if(current_move.move['type'] == ShipMove.MoveType.SPECIAL):
			disableRadar(current_move.move['time'])
			var special_function = current_move.move.get('func')
			if(special_function && self.has_method(special_function)):
				Callable(self, special_function).call(current_move.move['time'])
			




func get_move() -> ShipMove:
	if Input.is_action_pressed("move_right"+str(player_index)):
		return ShipMove.create(ShipMove.Moves.SMALL_CURVE_RIGHT)
	if Input.is_action_pressed("move_left"+str(player_index)):
		return ShipMove.create(ShipMove.Moves.SMALL_CURVE_LEFT)
	if Input.is_action_pressed("move_down"+str(player_index)):
		return ShipMove.create(ShipMove.Moves.STOP)
	if Input.is_action_pressed("move_up"+str(player_index)):
		return ShipMove.create(ShipMove.Moves.RETO)
	return null

func get_secondary_move() -> ShipMove:
	if Input.is_action_pressed("move_right"+str(player_index)):
		return ShipMove.create(ShipMove.Moves.CURVE_RIGHT)
	if Input.is_action_pressed("move_left"+str(player_index)):
		return ShipMove.create(ShipMove.Moves.CURVE_LEFT)
	if Input.is_action_pressed("move_down"+str(player_index)):
		return null
	if Input.is_action_pressed("move_up"+str(player_index)):
		return ShipMove.create(ShipMove.Moves.RETO_LONGO)
	return null
	
func get_special_move() -> ShipMove:
	if Input.is_action_pressed("move_right"+str(player_index)):
		return ShipMove.create(ShipMove.Moves.CENTO80_RIGHT)
	if Input.is_action_pressed("move_left"+str(player_index)):
		return ShipMove.create(ShipMove.Moves.CENTO80_LEFT)
	if Input.is_action_pressed("move_up"+str(player_index)):
		return ShipMove.create(ShipMove.Moves.RAM)
	if Input.is_action_pressed("move_down"+str(player_index)):
		return ShipMove.create(ShipMove.Moves.GRANADE)
	return null

func _on_colision_imunity_timeout() -> void:
	colisionImunity = false
