extends Area2D

class_name Radar

var width: float = 0
var height: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent: Ship = get_parent()
	height = parent.radarHeight
	width = parent.radarWidth
	scale = Vector2(height,width)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func disable_radar(): 
	$DisabledRadar.stop()
	$DisabledRadar.start()
	scale = Vector2(0,0)
	hide()
	set_deferred("disabled", true) 

	
func _on_disabled_radar_timeout() -> void:
	scale = Vector2(0,0)
	show()
	var tween: Tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "scale", Vector2(height,width),2)
	set_deferred("disabled", false)
	
