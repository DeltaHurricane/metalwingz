extends RigidBody2D
class_name Ship

signal start_dmg(body: Node2D)
signal stop_dmg(body: Node2D)
signal dead(name: String)

var move_list: Array[ShipMove] = []

@export var health:float = 3
@export var radarHeight:float = 0.9
@export var radarWidth:float = 1.0
@export var max_speed:int = 200 # How fast the player will move (pixels/sec).
var screen_size: int # Size of the game window.
var current_move: ShipMove = ShipMove.create(ShipMove.Moves.RETO)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#on_colision() #começar sem o radar
	

func _process(delta: float) -> void:
	apply_impulse(Vector2.UP.rotated(rotation) * current_move.move[ShipMove.Dir.FORCE]  * delta)
	apply_torque_impulse(current_move.move[ShipMove.Dir.TORQUE]  * delta)
	var colision: int = get_contact_count()
	if(colision != 0):
		on_colision()
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
	

func on_colision() -> void: 
	var radar: Radar = $Radar
	radar.disable_radar()


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
		return null
	if Input.is_action_pressed("move_up"):
		return ShipMove.create(ShipMove.Moves.RETO_LONGO)
	return null


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.shift_pressed:
			add_move(get_secondary_move())
		else:
			add_move(get_move())


func _on_next_move_timeout() -> void:
	if(move_list.size() > 0):
		current_move = move_list.pop_front()
	else:
		current_move = ShipMove.create(ShipMove.Moves.RETO)
	
func add_move(move_obj:ShipMove):
	if move_obj != null && move_list.size() < 4:
		move_list.append(move_obj)


func old_movimentos():
	pass
		#var impulse:int = 0
	#var torque:int = 0
	#if Input.is_action_pressed("move_right"):
		#torque = 500
	#if Input.is_action_pressed("move_left"):
		#torque = -500
	#if Input.is_action_pressed("move_down"):
		#impulse = -1000
		##add_constant_force(Vector2.UP.rotated(rotation) * impulse  * delta)
	#if Input.is_action_pressed("move_up"):
		#impulse = 1000
		##add_constant_central_force(Vector2.UP.rotated(rotation) * impulse )
		#
	#apply_impulse(Vector2.UP.rotated(rotation) * impulse  * delta)
	#apply_torque_impulse(torque  * delta)
	
	
