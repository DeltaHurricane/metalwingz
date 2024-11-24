extends Node2D

class_name Shields

var shield = preload("./shields_body.tscn")

signal remove()

var parent = null
var current_shield = null

func _ready() -> void:
	parent = get_parent()
	self.position = Vector2(0,-25)
	
	
func activate(time:float):
	$ActiveTimer.stop()
	$ActiveTimer.start(time)
	

func _on_active_timer_timeout() -> void:
	remove.emit()
	queue_free()

func _process(delta: float) -> void:
	removeShield()
	var newShield: ShieldsBody = shield.instantiate()
	newShield.linear_velocity = parent.linear_velocity
	newShield.angular_velocity = parent.angular_velocity
	add_child(newShield)
	current_shield = newShield
	
	
func removeShield():
	if(current_shield):
		current_shield.queue_free()
		current_shield = null
