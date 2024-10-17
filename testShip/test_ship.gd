extends Node2D

@export var health:int = 10


signal teste()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	



	
func hit():
	health -= 1


func _on_teste() -> void:
	queue_free()
