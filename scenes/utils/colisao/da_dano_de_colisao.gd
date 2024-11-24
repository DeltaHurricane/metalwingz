extends Node

@export var colision_damage: float = 0.3
@export var nodeColisor: CollisionObject2D

func _ready() -> void:
	nodeColisor.connect("body_entered",daDano)
	
func daDano(body: Node2D) -> void:
	if(body && body.has_method('on_colision')):
		Callable(body, 'on_colision').call(colision_damage)
