extends RigidBody2D

class_name  Granada

@export var granada_powa:int = 1000

var timeout: float
var incDec: bool = true
var exploded: bool = false
var activated = false


func _ready() -> void:
	$Explosao.visible = false
	decrease()
	
	
func _process(delta: float) -> void:
	getFrameHitbox()
	
func increase():
	var tween: Tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "scale", Vector2(1,1),1)
	incDec = false

func decrease():
	var tween: Tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "scale", Vector2(0.9,0.9),1)
	incDec = true


func _on_timer_timeout() -> void:
	if(incDec):
		increase()
	else: 
		decrease()


func _on_body_entered(body: Node2D) -> void:
	if(body is Ship):
		explode()
		var direction = self.position.direction_to(body.position) 
		body.apply_central_impulse(direction * granada_powa)


func _on_explosao_animation_finished() -> void:
	queue_free()

func explode():
	if(not exploded):
		$Timer.stop()
		self.linear_damp = 1000000
		self.angular_damp = 1000000
		self.set_collision_layer_value(3, false)
		self.set_collision_layer_value(1, false)
		self.set_collision_mask_value(3, false)
		exploded = true
		$Explosao.visible = true
		$GranadaInerte.visible = false
		$Explosao.play("default")

func _on_inerte_timer_timeout() -> void:
	explode()

func getFrameHitbox():
	if(activated):
		var frame_count = range(8)
		for x in frame_count:
			var node = get_node("Hitbox_" + str(x))
			node.disabled = (x != $Explosao.frame)
			node.visible = (x == $Explosao.frame)


func _on_activation_timeout() -> void:
	activated = true
