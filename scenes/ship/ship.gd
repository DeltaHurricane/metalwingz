extends RigidBody2D
class_name Ship

signal start_dmg(body: Node2D)
signal stop_dmg(body: Node2D)
signal dead(name: String)
signal change_ship_hp(new_hp: float)
signal change_moves(moves: Array[ShipMove])

var move_list: Array[ShipMove] = []
var current_move: ShipMove = ShipMove.create(ShipMove.Moves.RETO)
var colisionImunity: bool = false
var colision_damage: float = 0.3
var max_moves: int = 4

@export var player_index: int = 0
@export var health:float = 3.0
@export var radarHeight:float = 0.9
@export var radarWidth:float = 1.0
@export var max_speed:int = 200 # How fast the player will move (pixels/sec).

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#on_colision() #começar sem o radar
	

func _process(delta: float) -> void:
	apply_central_impulse(Vector2(Vector2.UP.rotated(rotation) * current_move.move[ShipMove.Dir.FORCE]  * delta))
	apply_torque_impulse(current_move.move[ShipMove.Dir.TORQUE]  * delta)
	var colision: int = get_contact_count()
	if(colision != 0 && colisionImunity == false):
		on_colision(get_colliding_bodies())
		#print(colision)
		#print(get_colliding_bodies())
		#print(linear_velocity)
		#print(rad_to_deg(rotation))
	if(health <= 0):
		dead.emit(self.name)
		queue_free()
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var leng: int = min(max_speed, state.linear_velocity.length())
	state.linear_velocity = state.linear_velocity.normalized() * leng
	
func hit(dano: float) -> void:
	health -= dano
	AutoloadedSignals.change_ship_hp.emit(player_index,health)


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
	

func on_colision(colisionBodies: Array[Node2D]) -> void: 
	var radar: Radar = $Radar
	radar.disable_radar()
	
	var recieving_colision_damage = 0.0
	var is_valid_colision = false

	for objeto in colisionBodies:
		if objeto is Ship:
			recieving_colision_damage = objeto.colision_damage
			is_valid_colision = true
			break
				
	if(is_valid_colision):
		colisionImunity = true
		hit(recieving_colision_damage)
		$ColisionImunity.start()


func get_move() -> ShipMove:
	if Input.is_action_pressed("move_right"):
		return ShipMove.create(ShipMove.Moves.SMALL_CURVE_RIGHT)
	if Input.is_action_pressed("move_left"):
		return ShipMove.create(ShipMove.Moves.SMALL_CURVE_LEFT)
	if Input.is_action_pressed("move_down"):
		return ShipMove.create(ShipMove.Moves.STOP)
	if Input.is_action_pressed("move_up"):
		return ShipMove.create(ShipMove.Moves.RETO)
	return null

func get_secondary_move() -> ShipMove:
	if Input.is_action_pressed("move_right"):
		return ShipMove.create(ShipMove.Moves.CURVE_RIGHT)
	if Input.is_action_pressed("move_left"):
		return ShipMove.create(ShipMove.Moves.CURVE_LEFT)
	if Input.is_action_pressed("move_down"):
		move_list = []
		change_moves.emit(move_list)
		return null
	if Input.is_action_pressed("move_up"):
		return ShipMove.create(ShipMove.Moves.RETO_LONGO)
	return null


func _unhandled_input(event: InputEvent) -> void:
	if player_index == 0:
		if event is InputEventKey and event.pressed:
			if event.shift_pressed:
				add_move(get_secondary_move())
			else:
				add_move(get_move())
	else:
		if event is InputEventJoypadButton and event.pressed:
			if Input.is_joy_button_pressed(player_index-1,JOY_BUTTON_A):
				add_move(get_secondary_move2())
			else:
				add_move(get_move2())
			

func _on_next_move_timeout() -> void:
	if(move_list.size() > 0):
		current_move = move_list.pop_front()
		change_moves.emit(move_list)
	else:
		current_move = ShipMove.create(ShipMove.Moves.RETO)
	
func add_move(move_obj:ShipMove) -> void:
	if move_obj != null && move_list.size() < max_moves:
		move_list.append(move_obj)
		change_moves.emit(move_list)

func get_move2() -> ShipMove:
	if Input.is_joy_button_pressed(player_index-1,JOY_BUTTON_DPAD_RIGHT):
		return ShipMove.create(ShipMove.Moves.SMALL_CURVE_RIGHT)
	if Input.is_joy_button_pressed(player_index-1,JOY_BUTTON_DPAD_LEFT):
		return ShipMove.create(ShipMove.Moves.SMALL_CURVE_LEFT)
	if Input.is_joy_button_pressed(player_index-1,JOY_BUTTON_DPAD_DOWN):
		return ShipMove.create(ShipMove.Moves.STOP)
	if Input.is_joy_button_pressed(player_index-1,JOY_BUTTON_DPAD_UP):
		return ShipMove.create(ShipMove.Moves.RETO)
	return null

func get_secondary_move2() -> ShipMove:
	if Input.is_joy_button_pressed(player_index-1,JOY_BUTTON_DPAD_RIGHT):
		return ShipMove.create(ShipMove.Moves.CURVE_RIGHT)
	if Input.is_joy_button_pressed(player_index-1,JOY_BUTTON_DPAD_LEFT):
		return ShipMove.create(ShipMove.Moves.CURVE_LEFT)
	if Input.is_joy_button_pressed(player_index-1,JOY_BUTTON_DPAD_DOWN):
		move_list = []
		change_moves.emit(move_list)
		return null
	if Input.is_joy_button_pressed(player_index-1,JOY_BUTTON_DPAD_UP):
		return ShipMove.create(ShipMove.Moves.RETO_LONGO)
	return null


func _on_colision_imunity_timeout() -> void:
	colisionImunity = false
