extends RigidBody2D
class_name Ship

signal start_dmg(body: Node2D)
signal stop_dmg(body: Node2D)
signal dead(name: String)

@export var health:float = 3
@export var radarHeight:float = 1.0
@export var radarWidth:float = 1.0
@export var max_speed:int = 200 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#on_colision() #começar sem o radar
	

func _process(delta: float) -> void:
	var impulse = 0
	var torque = 0
	if Input.is_action_pressed("move_right"):
		torque = 500
	if Input.is_action_pressed("move_left"):
		torque = -500
	if Input.is_action_pressed("move_down"):
		impulse = -1000
	if Input.is_action_pressed("move_up"):
		impulse = 1000
		
	apply_impulse(Vector2.UP.rotated(rotation) * impulse  * delta)
	apply_torque_impulse(torque  * delta)
	
	var colision = get_contact_count()
	if(colision != 0):
		on_colision()
		#print(colision)
		#print(get_colliding_bodies())
		#print(linear_velocity)
		#print(rad_to_deg(rotation))
	if(health <= 0):
		dead.emit(self.name)
		queue_free()
	
func _integrate_forces(state):
	var leng = min(max_speed, state.linear_velocity.length())
	state.linear_velocity = state.linear_velocity.normalized() * leng
	
func hit(dano: float):
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
	

func on_colision(): 
	$Radar.disable_radar()
