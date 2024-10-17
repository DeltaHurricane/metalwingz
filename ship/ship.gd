extends RigidBody2D

@export var health:int = 10
@export var max_speed:int = 200 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

func _process(delta: float) -> void:
	var impulse = 0
	var torque = 0
	if Input.is_action_pressed("move_right"):
		torque = 200
		impulse = 50
		
		
	if Input.is_action_pressed("move_left"):
		torque = -200
		impulse = 50
		
		
	if Input.is_action_pressed("move_down"):
		impulse = -1000
	if Input.is_action_pressed("move_up"):
		impulse = 1000
		
	apply_impulse(Vector2.UP.rotated(rotation) * impulse  * delta)
	apply_torque_impulse(torque  * delta)
	
	var colision = get_contact_count()
	if(colision != 0):
		on_colision()
		print(colision)
		print(get_colliding_bodies())
		print(linear_velocity)
		print(rad_to_deg(rotation))
	
func _integrate_forces(state):
	var leng = min(max_speed, state.linear_velocity.length())
	state.linear_velocity = state.linear_velocity.normalized() * leng
	
func hit():
	health -=1


func _on_radar_body_entered(body: Node2D) -> void:
	print((body.global_position.distance_to(global_position)))
	print(body)
	print(body.has_signal('teste'))
	if(body.has_method('teste')):
		body.teste.emit()
	

func on_colision():
	$DisabledRadar.stop()
	$DisabledRadar.start()
	var radar: Area2D = $Radar
	radar.scale = Vector2(0,0)
	radar.hide()
	#teste
	radar.set_deferred("disabled", true) 

	


func _on_disabled_radar_timeout() -> void:
	var radar: Area2D = $Radar
	radar.scale = Vector2(0,0)
	radar.show()
	radar.set_deferred("disabled", false)
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(radar, "scale", Vector2(1,1),2)
	
