extends RigidBody2D

class_name Asteroido

@export var tamanho: float = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.scale *= tamanho
	$CollisionPolygon2D.scale *= tamanho


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
